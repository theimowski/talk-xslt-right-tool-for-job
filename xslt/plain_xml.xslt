<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="http://example.com">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>
  <xsl:template match="/invoice">
    <xsl:copy-of select="my:applyDiscounts(product)" />
  </xsl:template>
  <xsl:variable as="element(discount)+" name="discounts">
    <discount type="percent" sku="002" percent="30" />
    <discount type="XforY" sku="003" x="3" y="2" />
  </xsl:variable>
  <xsl:function as="xs:double" name="my:applyDiscounts">
    <xsl:param as="element(product)+" name="products" />
    <xsl:copy-of select="$products!my:applyDiscount(.) => sum()" />
  </xsl:function>
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
  
</xsl:stylesheet>