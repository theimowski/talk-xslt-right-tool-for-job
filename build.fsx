#I @"packages/FsReveal/fsreveal/"
#I @"packages/FAKE/tools/"
#I @"packages/Suave/lib/net40"

#r "FakeLib.dll"
#r "Suave.dll"
#r @"System.Xml.Linq"
#r @"packages/Saxon-HE/lib/net40/saxon9he.dll"
#r @"packages/Saxon-HE/lib/net40/saxon9he-api.dll"

#load "fsreveal.fsx"

// Git configuration (used for publishing documentation in gh-pages branch)
// The profile where the project is posted
let gitOwner = "theimowski"
let gitHome = "https://github.com/" + gitOwner
// The name of the project on GitHub
let gitProjectName = "talk-xslt-right-tool-for-job"

open FsReveal
open Fake
open Fake.Git
open System
open System.IO
open System.Diagnostics
open System.Text
open System.Xml
open System.Xml.Linq
open Saxon.Api
open Suave
open Suave.Web
open Suave.Http
open Suave.Operators
open Suave.Sockets
open Suave.Sockets.Control
open Suave.Sockets.AsyncSocket
open Suave.WebSocket
open Suave.Utils
open Suave.Files

let outDir = __SOURCE_DIRECTORY__ </> "output"
let slidesDir = __SOURCE_DIRECTORY__ </> "slides"

Target "Clean" (fun _ ->
    CleanDirs [outDir]
)

let fsiEvaluator = 
    let evaluator = FSharp.Literate.FsiEvaluator()
    evaluator.EvaluationFailed.Add(fun err -> 
        traceImportant <| sprintf "Evaluating F# snippet failed:\n%s\nThe snippet evaluated:\n%s" err.StdErr err.Text )
    evaluator 

let copyStylesheet() =
    try
        CopyFile (outDir </> "css" </> "custom.css") (slidesDir </> "custom.css")
    with
    | exn -> traceImportant <| sprintf "Could not copy stylesheet: %s" exn.Message

let copyPics() =
    try
      CopyDir (outDir </> "images") (slidesDir </> "images") (fun f -> true)
    with
    | exn -> traceImportant <| sprintf "Could not copy picture: %s" exn.Message

let generateFor (file:FileInfo) = 
    try
        copyPics()
        let rec tryGenerate trials =
            try
                FsReveal.GenerateFromFile(file.FullName, outDir, fsiEvaluator = fsiEvaluator)
            with 
            | exn when trials > 0 -> tryGenerate (trials - 1)
            | exn -> 
                traceImportant <| sprintf "Could not generate slides for: %s" file.FullName
                traceImportant exn.Message

        tryGenerate 3

        copyStylesheet()
    with
    | :? FileNotFoundException as exn ->
        traceImportant <| sprintf "Could not copy file: %s" exn.FileName

let refreshEvent = new Event<_>()

let handleWatcherEvents (events:FileChange seq) =
    for e in events do
        let fi = fileInfo e.FullPath
        traceImportant <| sprintf "%s was changed." fi.Name
        match fi.Attributes.HasFlag FileAttributes.Hidden || fi.Attributes.HasFlag FileAttributes.Directory with
        | true -> ()
        | _ -> generateFor fi
    refreshEvent.Trigger()

let socketHandler (webSocket : WebSocket) =
  fun cx -> socket {
    while true do
      let! refreshed =
        Control.Async.AwaitEvent(refreshEvent.Publish)
        |> Suave.Sockets.SocketOp.ofAsync 
      do! webSocket.send Text (ASCII.bytes "refreshed") true
  }

let startWebServer () =
    let rec findPort port =
        let portIsTaken =
            if isMono then false else
            System.Net.NetworkInformation.IPGlobalProperties.GetIPGlobalProperties().GetActiveTcpListeners()
            |> Seq.exists (fun x -> x.Port = port)

        if portIsTaken then findPort (port + 1) else port

    let port = findPort 8083

    let serverConfig = 
        { defaultConfig with
           homeFolder = Some (FullName outDir)
           bindings = [ HttpBinding.mkSimple HTTP "127.0.0.1" port ]
        }
    let app =
      choose [
        Filters.path "/websocket" >=> handShake socketHandler
        Writers.setHeader "Cache-Control" "no-cache, no-store, must-revalidate"
        >=> Writers.setHeader "Pragma" "no-cache"
        >=> Writers.setHeader "Expires" "0"
        >=> browseHome ]
    startWebServerAsync serverConfig app |> snd |> Async.Start
    Process.Start (sprintf "http://localhost:%d/index.html" port) |> ignore

Target "GenerateSlides" (fun _ ->
    !! (slidesDir + "/**/*.md")
      ++ (slidesDir + "/**/*.fsx")
    |> Seq.map fileInfo
    |> Seq.iter generateFor
)

Target "KeepRunning" (fun _ ->
    use watcher = !! (slidesDir + "/**/*.*") |> WatchChanges handleWatcherEvents
    
    startWebServer ()

    traceImportant "Waiting for slide edits. Press any key to stop."

    System.Console.ReadKey() |> ignore

    watcher.Dispose()
)

Target "ReleaseSlides" (fun _ ->
    if gitOwner = "myGitUser" || gitProjectName = "MyProject" then
        failwith "You need to specify the gitOwner and gitProjectName in build.fsx"
    let tempDocsDir = __SOURCE_DIRECTORY__ </> "temp/gh-pages"
    CleanDir tempDocsDir
    Repository.cloneSingleBranch "" (gitHome + "/" + gitProjectName + ".git") "gh-pages" tempDocsDir

    fullclean tempDocsDir
    CopyRecursive outDir tempDocsDir true |> tracefn "%A"
    StageAll tempDocsDir
    Git.Commit.Commit tempDocsDir "Update generated slides"
    Branches.push tempDocsDir
)

let formatStaticError (e: StaticError) =
    sprintf 
        "Stylesheet compilation error:\n%s\n%s\nLine:%d" 
        e.Message 
        e.ModuleUri
        e.LineNumber 

let xslTransform xslt parameters input (output: string) =
    use stream = File.OpenRead xslt
    use inputStream = File.OpenRead input
    use sw = new StreamWriter(output)
    use tw = new XmlTextWriter(sw)
    let destination = TextWriterDestination(tw)
    
    let baseUri = System.Uri(@".", UriKind.Relative)
    let compiler = Processor().NewXsltCompiler(BaseUri = baseUri)
    let errors = Collections.ArrayList()
    compiler.ErrorList <- errors

    let executable = 
        //try 
            compiler.Compile(stream)
        //with _ -> 
        //    let msg =
        //        errors
        //        |> Seq.cast<obj>
        //        |> Seq.filter (fun x -> x :? StaticError)
        //        |> Seq.cast<StaticError>
        //        |> Seq.map formatStaticError
        //        |> String.concat Environment.NewLine
        //    
        //    failwith msg

    let transformer = executable.Load()
    transformer.SetInputStream(inputStream, baseUri)
    transformer.RecoveryPolicy <- RecoveryPolicy.DoNotRecover
    for (name: string, value: string) in parameters do
        transformer.SetParameter(QName(name), XdmAtomicValue(value))
    transformer.Run(destination)

Target "Transform" (fun _ -> 
        let xslt = getBuildParamOrDefault "xslt" ("." </> "xslt" </> "transform.xslt")
        let input = getBuildParamOrDefault "input" (currentDirectory </> "xslt" </> "input.xml") 
        let output = getBuildParamOrDefault "output" (currentDirectory </> "xslt" </> "output.xml")
        xslTransform xslt [] input output
    )


Target "ToolTransform" (fun _ ->
    let xslt = getBuildParamOrDefault "xslt" ("." </> "xslt" </> "transform.xslt")
    let input = getBuildParamOrDefault "input" (currentDirectory </> "xslt" </> "input.xml") 
    let output = getBuildParamOrDefault "output" (currentDirectory </> "xslt" </> "output.xml")
        
    let code =
        ExecProcess 
            (fun si ->
                si.FileName <- @"packages\Saxon-HE\tools\Transform.exe"
                si.Arguments <- 
                    sprintf
                        """-s:%s -o:%s -xsl:%s"""
                        input
                        output
                        xslt
            )
            (TimeSpan.FromSeconds 10.)

    if code <> 0 then failwith "failed to execute XSLT"
)

"Clean"
  ==> "GenerateSlides"
  ==> "KeepRunning"

"GenerateSlides"
  ==> "ReleaseSlides"
  
RunTargetOrDefault "KeepRunning"
