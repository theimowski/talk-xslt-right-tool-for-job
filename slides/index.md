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

---

## Intent

* We often express reluctance for specific technology, avoid it and try different solutions, while we could have used a dedicated tool (technology) in a proper manner to tackle the problem efficiently.
* This is not supposed to be a strictly technical talk, but I'd also like to send a message that we should be more open and reach for right tools when needed.  
* To do so I'd like to share our success story with XSLT in PDF component in Phoenix, plus show a couple of tips & tricks while working with XSLT.

***
- data-background : images/context2.jpg

<h2>&emsp;&emsp;&emsp;Context</h2>
</br>
</br>
</br>

---

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
- data-background : images/profit.jpg

## Profit
</br>
</br>
</br>

---

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

### numbers

* 3 IHS Domains
    * Chemical
    * Economics
    * Energy
* ~2.000 XSLT LOC
* ~2.000 PDF Reports Generated
* ~20.000 Pages of content

***
- data-background : images/practice.jpg

## Practice

' biggest pains?
' technical stuff
' for each pain -> solution

---

- data-background : images/explicit.jpg

---

## Practice

### Template matching conflicts
### "Implicit vs explicit" processing

<small>
Conventional approach is to define multiple templates matching a pattern and rely on "apply-templates" instruction.
However when a transform gets bigger and bigger it's hard to reason about those templates directly.
Specially when the schemes of transform's input and output differ a lot.
In addition one might get template matching conflicts which are not always easy to resolve - priorities.
Example - maybe just show and explain both approaches, not necessarily dive into complex examples.
First show the implicit approach, explain potential pains, and then show explicit approach and how it solves those problems.
Example domain - focus on transforming Dita XML to Modifier XML.
Explicit = named templates but also functions.
</small>

---

- data-background : images/complex.jpg

---

### Pessimist: Complex instructions
### Optimist: Functional stuff in new XSLT

* XPath power
* Utilize functions - come back to explicit processing
* Static Typing capabilities
* "Group by" capabilities - optionally

---

### XPath power
#### Inovice sum

Input

    [lang=xml]
    <invoice>
      <product sku="001" price="12.50" quantity="2" />
      <product sku="002" price="10.00" quantity="2" />
      <product sku="003" price="35.00" quantity="3" />
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

### XPath power
#### XPath 3.1 features

* expressions: conditional, quantified, logic, etc...
* list bind
* mapping - ! operator
* filtering
* aggregation functions
* arrow operator
* let bindings
* function calls

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
    <xsl:function as="element(product)" name="my:maxPrice">
      <xsl:param as="element(product)+" name="products" />
      <xsl:copy-of select="$products[@price = max($products/@price)]" />
    </xsl:function>

Static Error

    [lang=plaintext]
    Static error in {my:maxByPrice(.)} in expression in
    xsl:copy-of/@select on line 6 column 46 of static_typing.xslt:
        XPST0017: Cannot find a matching 1-argument function 
        named {http://example.com}maxByPrice()

---

- data-background : images/tree.jpg

---

### Pessimist: Terse XML syntax
### Optimist: There are pros of XML syntax

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

    [lang=xml]
    <xsl:variable as="element(discount)+" name="discounts">
      <discount type="percent" sku="002" percent="30" />
      <discount type="XforY" sku="003" x="3" y="2" />
    </xsl:variable>
    
    <xsl:template match="/invoice">
      <xsl:copy-of select="my:applyDiscounts(product)" />
    </xsl:template>
    
    <xsl:function as="xs:double" name="my:applyDiscounts">
      <xsl:param as="element(product)+" name="products" />
      <xsl:copy-of select="$products!my:applyDiscount(.) => sum()" />
    </xsl:function>


* Declarative nature of XML
* Return plain XML

---

### Applying discounts

    [lang=xml]
    <xsl:function as="xs:double" name="my:applyDiscount">
      <xsl:param as="element(product)" name="product" /> 
      <xsl:copy-of select="
        let $discount := $discounts[@sku = $product/@sku],
            $price    := $product/@price,
            $quantity := $product/@quantity
        return
            if ($discount/@type = 'percent') then 
                (100 - $discount/@percent) div 100 * $price * $quantity
            else if ($discount/@type = 'XforY') then
                let $discounted := $quantity div $discount/@x,
                    $remaining  := $quantity mod $discount/@x
                return
                    $discounted * $price * $discount/@y + 
                    $remaining  * $price
            else
                $price * $quantity" />
    </xsl:function>

---

- data-background : images/diagnostics.jpg

---

## Practice

### Pessimist: XSLT is Hard to diagnose
### Optimist: With FP I hardly need to debug. Also I can profile

---

#### Debugging

    [lang=xml]
    <xsl:function name="my:debug">
      <xsl:param name="msg" />
      <xsl:param name="x" />
      <xsl:message><xsl:value-of select="concat($msg, ': ', $x)"/></xsl:message>
      <xsl:copy-of select="$x" />
    </xsl:function>
    
---

    [lang=xml]
    <xsl:function as="xs:double" name="my:applyDiscount">
      <xsl:param as="element(product)" name="product" /> 
      <xsl:message>--- sku: <xsl:value-of select="$product/@sku"/></xsl:message>
      <xsl:copy-of select="
        let $discount := my:debug('discount', $discounts[@sku = $product/@sku]),
          $price    := my:debug('price', $product/@price),
          $quantity := my:debug('quantity', $product/@quantity)
        return
          if ($discount/@type = 'percent') then 
            (100 - $discount/@percent) div 100 * $price * $quantity
          else if ($discount/@type = 'XforY') then
            let $discounted := $quantity div $discount/@x,
              $remaining  := $quantity mod $discount/@x
            return
              $discounted * $price * $discount/@y + 
              $remaining  * $price
          else
            $price * $quantity" />
    </xsl:function>

---

    [lang=xml]
    --- sku: 001
    discount:
       price: <?attribute name="price" value="12.50"?>
    quantity: <?attribute name="quantity" value="2"?>
    --- sku: 002
    discount: <discount type="percent" sku="002" percent="30"/>
       price: <?attribute name="price" value="10.00"?>
    quantity: <?attribute name="quantity" value="2"?>
    --- sku: 003
    discount: <discount type="XforY" sku="003" x="3" y="2"/>
    quantity: <?attribute name="quantity" value="3"?>
       price: <?attribute name="price" value="35.00"?>

' concurrent execution? always same permutation

---

#### Profiling

![profiling.png](images/profiling.png)

---

- data-background : images/tooling.jpg

---

## Practice

### Poor tooling
### Editor extensions?

---

![no higlight.png](images/no_highlight.png)

---

![higlight.png](images/highlight.png)

---

- data-background : images/property.jpg

---

## Practice

### Saxon's monopoly
### Supplements for free-version processor

---

#### Only in commercial Saxon Editions

* schema-awareness
* higher-order functions
* streaming
* various performance optimizations
* more extension points

http://www.saxonica.com/products/feature-matrix-9-6.xml

***
- data-background : images/recap.jpg

<h2 style="color: white">&nbsp;&nbsp;Recap</h2>

---

## Recap

* lessons learned
* the very purpose of XSLT is to transform XML documents
* One can handle XSLT to use it without big pain
* It's not just about XSLT
* We don't have to avoid unknown tools / technologies
* We can discover interesting ways of using these tools to improve our process
* In the end what really matters is the final result that has business value