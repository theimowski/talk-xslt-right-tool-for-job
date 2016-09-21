- title : XSLT - Use the Right Tool for the Job
- description : XSLT - Use the Right Tool for the Job
- author : Tomasz Heimowski
- theme : white
- transition : slide

***
- data-background : images/screwer.jpg


# XSLT
## Use the Right Tool for the Job

</br>
</br>
</br>

### Tomasz Heimowski

http://theimowski.com/

@theimowski

![ihsmarkit](images/ihsmarkit.svg)

***
'   - data-background : images/intent.jpeg
'   
'   ## Intent
'   </br>
'   
'   ---

## Intent

* We often express reluctance for specific technology, avoid it and try different solutions, while we could have used a dedicated tool (technology) in a proper manner to tackle the problem efficiently.
* This is not supposed to be a strictly technical talk, but I'd also like to send a message that we should be more open and reach for right tools when needed.  
* To do so I'd like to share our success story with XSLT in PDF component in Phoenix, plus show a couple of tips & tricks while working with XSLT.

***
'   - data-background : images/context2.jpg
'   
'   <h2>&emsp;&emsp;&emsp;Context</h2>
'   </br>
'   </br>
'   </br>
'   
'   ---

## Context

* Show what we do in Phoenix project
* Describe digital publishing and explain the importance of its automation in IHS
* Present big picture of PDF publishing architecture in Phoenix
* Highlight the XSLT building block in PDF rendition flow
* Review the level of knowledge at the beginning of working on the transform
* Share how the approach advanced while developing the transform
* Note that we didn't stick to the conventional approach
* I'm not an expert

***
'   - data-background : images/profit.jpg
'   
'   ## Profit
'   </br>
'   </br>
'   </br>
'   
'   ---

## Profit

* Boost the progress
* Show examples of rendered PDF reports
* Explain the complexity of transform by listing all possible rendition templates, layouts, options and modes
* Present numbers: 
    * lines of XSLT code, 
    * total reports rendered in Phoenix, 
    * total number of pages of all reports,
    * other counters?
* ? Mention full migration of IHS CMS that was hard to maintain

***
'   - data-background : images/practice.jpg
'   
'   ## Practice
'   
'   ---

## Practice

### Template matching conflicts
### "Implicit vs explicit" processing

---

## Practice

### Forcing imperative approach
### Functional programming paradigm

---

## Practice

### Complex instructions
### Features in new versions of XSLT

* The power of XPath expressions
* Static Typing capabilities
* Utilize functions
* "Group by" capabilities

---

## Practice

### Terse XML syntax
### Point out advantages of XML syntax

---

## Practice

### Saxon's monopoly
### Supplements for free-version processor

---

## Practice

### Difficult diagnostics
### Debugging, profiling

***
'   - data-background : images/recap.jpg
'   
'   <h2 style="color: white">&nbsp;&nbsp;Recap</h2>
'   
'   ---

## Recap

* lessons learned
* the very purpose of XSLT is to transform XML documents
* One can handle XSLT to use it without big pain
* It's not just about XSLT
* We don't have to avoid unknown tools / technologies
* We can discover interesting ways of using these tools to improve our process
* In the end what really matters is the final result that has business value