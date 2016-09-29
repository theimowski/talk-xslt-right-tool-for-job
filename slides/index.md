- title : XSLT - Use the Right Tool for the Job
- description : XSLT - Use the Right Tool for the Job
- author : Tomasz Heimowski
- theme : white
- transition : slide

***
- data-background : images/wrench.jpg


# XSLT
### Use the Right Tool for the Job

</br>
</br>
</br>
</br>

http://theimowski.com/

@theimowski

![ihsmarkit](images/ihsmarkit.svg)

***
- data-background : images/intent.jpeg

## Intent
</br>

' Why I'm here talking XSLT
' What I'd like you to get from this talk

---

- data-background : images/dentist.jpg

' We often express reluctance for specific technology, avoid it and try different solutions, while we could have used a dedicated tool (technology) in a proper manner to tackle the problem efficiently.

---

- data-background : images/horizon.jpg

' This is not supposed to be a strictly technical talk, but I'd also like to send a message that we should be more open and reach for right tools when needed.  

---

- data-background : images/success.jpg

' To do so I'd like to share our success story with XSLT in PDF component in Phoenix, plus show a couple of tips & tricks while working with XSLT.

---

- data-background : images/alone.jpg

' Share the story about CFP for DevDay and "Come on, XSLT?"
' I'm happy to talk about niche XSLT, to prove that you can do really cool stuff with even unfamous technologies

***
- data-background : images/context2.jpg

<h2>&emsp;&emsp;&emsp;Context</h2>
</br>
</br>
</br>

' What we do
' What problem to solve
' Why XSLT

---

- data-background : images/firebird.jpg

' IHS Markit big corporation providing information in various domains
' IT dept primarily responsible for visualising and storing the information
' Many CMS inside company
' Show what we do in Phoenix project

---

- data-background : images/digitalpub.jpg

' One of aspects in Phoenix is DP
' Describe digital publishing and explain the importance of its automation in IHS

---

<div>
    <img  style="display: inline-block;vertical-align:middle;border:none;box-shadow:none" width="12%" src="images/qxp.jpg"/>
    <span style="font-size:80px;vertical-align:bottom;">&nbsp;↘&nbsp;</span>
</div>

<div>
    <img  style="display: inline-block;vertical-align:middle;border:none;box-shadow:none" width="24%" src="images/dita-logo.jpg"/>
    <span style="font-size:80px;color:red">&nbsp;→&nbsp;</span>
    <img  style="display: inline-block;vertical-align:middle;border:none;box-shadow:none" width="12%" src="images/xml.png"/>
    <span style="font-size:80px">&nbsp;→&nbsp;</span>
    <img  style="display: inline-block;vertical-align:middle;border:none;box-shadow:none" width="8%" src="images/qxps.jpg"/>
    <span style="font-size:80px">&nbsp;→&nbsp;</span>
    <img  style="display: inline-block;vertical-align:middle;border:none;box-shadow:none" width="18%" src="images/pdf.png"/>
</div>

' Present big picture of PDF publishing architecture in Phoenix
' Highlight the XSLT building block in PDF rendition flow
' Mention Full auto and Semi auto layout

---

- data-background : images/beginner.jpg

' Review the level of knowledge at the beginning of working on the transform
' XSLT quickly

---

- data-background : images/climbing.jpg

' Share how the approach advanced while developing the transform
' Continuous delivery pipeline

---

- data-background : images/unconventional.jpg

' Note that we didn't stick to the conventional approach
' Influence of FP

---

- data-background : images/learning.jpg

' I'm not an expert

***
- data-background : images/profit.jpg

## Profit
</br>
</br>
</br>

' Results drive motivation

---

<div >
    <img src="images/front_fc.png" style="display: inline-block;vertical-align:middle" width="48%"/>
    <img src="images/front_mhrp.png" style="display: inline-block;vertical-align:middle" width="48%"/>
</div>

---

<div >
    <img src="images/front_mhco.png" style="display: inline-block;vertical-align:middle" width="48%"/>
    <img src="images/front_mhbp.png" style="display: inline-block;vertical-align:middle" width="48%"/>
</div>

---

<div >
    <img src="images/front_mh2co.png" style="display: inline-block;vertical-align:middle" width="48%"/>
    <img src="images/front_mh2et.png" style="display: inline-block;vertical-align:middle" width="48%"/>
</div>

---

## features

* 7 different report templates
* 1 or 2 column text flow
* 8 different layout options for tables and charts
* advanced page break manipulation
* table break manipulation
* facing pages option
* suppressing specific objects and pages
* table of contents configuration
* support for large tables
* more...

---

<div >
    <img src="images/features_01.png" style="display: inline-block;vertical-align:middle" width="48%"/>
    <img src="images/features_03.png" style="display: inline-block;vertical-align:middle" width="48%"/>
</div>

---

<div>
    <img src="images/features_04_landscape.png" style="display: inline-block;vertical-align:middle" width="86%"/>
</div>

---

<div >
    <img src="images/features_05_fp.png" style="display: inline-block;vertical-align:middle" width="96%"/>
</div>

---

### numbers

* 3 IHS Domains
    * Chemical
    * Economics
    * Energy
* ~2.000 XSLT LOC
* ~2.000 PDF Reports Generated
    * 1 page long (smallest report)
    * 300 pages long (largest report)
* ~20.000 Pages of content
* Much more yet to come

' Chemical - complete migration of a legacy CMS hard to maintain
' Some of those reports cost a lot of money

***
- data-background : images/practice.jpg

## Practice

' technical stuff
' will be snippets - don't need to follow up
' tips & tricks
' biggest pains?
' solutions to some of the pains
' Utilize new xslt features

---

- data-background : images/explicit.jpg

---

### Implicit

![implicit](images/implicit.png)

' Conventional approach is to define multiple templates matching a pattern and rely on "apply-templates" instruction.
' However when a transform gets bigger and bigger it's hard to reason about those templates directly.
' Specially when the schemes of transform's input and output differ a lot.
' In addition one might get template matching conflicts which are not always easy to resolve - priorities.

---

### Explicit

![explicit](images/explicit.png)

---

- data-background : images/complex.jpg

' * Complex instructions
' * functional stuff in new XSLT
' * XPath power
' * Utilize functions
' * Static Typing capabilities
' * ? "Group by" capabilities

---

### XPath
#### Inovice sum

Input

    [lang=xml]
    <invoice>
      <product sku="001" price="12.50" quantity="2" />
      <product sku="002" price="10.00" quantity="2" />
      <product sku="003" price="35.00" quantity="3" />
      ...
    </invoice>

Expected output

    [lang=xml]
    150

---

#### Inovice sum - XSLT 1.0 with recursion

    [lang=xml]
    <xsl:template match="/invoice">
      <xsl:call-template name="sum">
        <xsl:with-param name="products" select="product" />
      </xsl:call-template>
    </xsl:template>
    <xsl:template name="sum">
      <xsl:param name="products" />
      <xsl:param name="acc" select="0" />
      <xsl:choose>
        <xsl:when test="not($products)">
          <xsl:value-of select="$acc" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="price" select="$products[1]/@price" />
          <xsl:variable name="quantity" select="$products[1]/@quantity" />
          <xsl:call-template name="sum">
            <xsl:with-param name="products" select="$products[position() > 1]" />
            <xsl:with-param name="acc" select="$acc + ($quantity * $price)" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

' not going to analyze this snippet
' only need to know that recursion is used here
' explain algorithm with C#

---

#### Inovice sum - C# with recursion

    [lang=csharp]
    public static string Transform(XDocument xdoc)
    {
        return Sum(xdoc.Root.Elements("product"));
    }

    private static string Sum(IEnumerable<XElement> elements, decimal acc = 0)
    {
        if (elements.Any() == false)
        {
            return acc.ToString();
        }
        else
        {
            var product = elements.ElementAt(0);
            var price = decimal.Parse(product.Attribute("price").Value);
            var quantity = decimal.Parse(product.Attribute("quantity").Value);
            return Sum(elements.Skip(1), acc + price*quantity);
        }
    }

---

#### Invoice sum - C# LINQ expression

    [lang=csharp]
    public static string Transform(XDocument xdoc)
    {
        return
            xdoc.Root.Elements("product")
                .Select(product => 
                            decimal.Parse(product.Attribute("price").Value) * 
                            decimal.Parse(product.Attribute("quantity").Value))
                .Sum()
                .ToString();
    }

---

#### Inovice sum - XSLT 3.0 with XPath 3.1

    [lang=xml]
    <xsl:template match="/invoice">
      <xsl:value-of select="product!(@price * @quantity) => sum()"/>
    </xsl:template>

---

#### XPath features

* expressions: conditional, quantified, logic, etc...
* concise syntax
* list collect
* list map
* list filter
* functions
* arrow operator
* let bindings

http://www.saxonica.com/documentation/index.html#!expressions

' XPath is a language itself

---

### Functions
#### Finding most expensive product

Input

    [lang=xml]
    <invoice>
      <product sku="001" price="12.50" quantity="2" />
      <product sku="002" price="10.00" quantity="2" />
      <product sku="003" price="35.00" quantity="3" />
    </invoice>

Expected output

    [lang=xml]
    <product sku="003" price="35.00" quantity="3" />

' refactor the example

---

#### Finding most expensive product - named template

    [lang=xml]
    <xsl:template match="/invoice">
      <xsl:call-template name="maxByPrice">
          <xsl:with-param name="products" select="product" />
      </xsl:call-template>
    </xsl:template>

    <xsl:template name="maxByPrice">
      <xsl:param name="products" />
      <xsl:copy-of select="$products[@price = max($products/@price)]" />
    </xsl:template>

---

#### Finding most expensive product - function

    [lang=xml]
    <xsl:template match="/invoice">
      <xsl:copy-of select="my:maxByPrice(product)" />
    </xsl:template>
    
    <xsl:function name="my:maxByPrice">
      <xsl:param name="products" />
      <xsl:copy-of select="$products[@price = max($products/@price)]" />
    </xsl:function>

---

#### XSLT Functions

* More concise syntax
* Can be used in XPath expressions
* Isolated - no implicit context nodes

---

### Static Typing

    [lang=xml]
    <xsl:template match="/invoice">
      <xsl:copy-of select="my:maxByPrice(.)" />
    </xsl:template>
    
    <xsl:function as="element(product)" name="my:maxByPrice">
      <xsl:param as="element(product)+" name="products" />
      <xsl:copy-of select="$products[@price = max($products/@price)]" />
    </xsl:function>

Static Error

    [lang=text]
    Static error at char 15 in xsl:copy-of/@select 
    on line 6 column 46 of static_typing.xslt:
        XPTY0004: Required item type of first argument 
        of my:maxByPrice() is element(Q{}product);
        supplied value has item type element(Q{}invoice)
    Errors were reported during stylesheet compilation

---

- data-background : images/tree.jpg

' Pessimist: Terse XML syntax
' Optimist: There are pros of XML syntax
' Mixing XPath code with XML syntax = more concise

---

### XML syntax
#### Applying discounts

Input

    [lang=xml]
    <invoice>
      <product sku="001" price="12.50" quantity="2" />
      <product sku="002" price="10.00" quantity="2" />
      <product sku="003" price="35.00" quantity="3" />
    </invoice>

* Get 30% discount for product with "002" sku
* Buy 3 for 2 products with "003" sku

Expected output

    [lang=xml]
    109

---

### Applying discounts

![declarative_xml.png](images/declarative_xml.png)
    
---

### Applying discounts

![applydiscount.png](images/applydiscount.png)

' Also good for returning bigger chunks of bare XML

---

- data-background : images/diagnostics.jpg

' Pessimist: XSLT is Hard to diagnose
' Optimist: With FP I hardly need to debug. Also I can profile

---

#### Debugging

![debugapplydiscount.png](images/debugapplydiscount.png)

' red squares?

---

![mydebug.png](images/mydebug.png)

---

![debugconsole.png](images/debugconsole.png)

---

#### Profiling

![profiling.png](images/profiling.png)

---

- data-background : images/tooling.jpg

' Poor tooling
' Oxygen XML Editor
' Rather nothing more than standard XML tooling
' Use scripts for testing the transform
' Editor extensions?

---

![no higlight.png](images/no_highlight.png)

---

![higlight.png](images/highlight.png)

---

- data-background : images/property.jpg

' Saxon's monopoly
' Supplements for free-version processor

---

#### Only in commercial Saxon Editions

* higher-order functions
* schema-awareness
* streaming
* various performance optimizations
* more extension points

http://www.saxonica.com/products/feature-matrix-9-6.xml

***
- data-background : images/recap.jpg

<h2 style="color: white">&nbsp;&nbsp;Recap</h2>

' lessons learned

---

- data-background : images/tools.jpg

' the very purpose of XSLT is to transform XML documents
' One can handle XSLT to use it without big pain
' It's not just about XSLT

---

- data-background : images/discover.jpg

' We don't have to avoid unknown tools / technologies
' We can discover interesting ways of using these tools to improve our process

---

- data-background : images/goal.jpg

' In the end what really matters is the final result that has business value