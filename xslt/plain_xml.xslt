<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="http://example.com">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>

  <!-- declarative nature of XML -->
  <!-- can use plain XML return values -->
  <xsl:variable as="element(discount)+" name="discounts">
    <discount sku="002" type="percent" percent="30" />
    <discount sku="003" type="XforY"   x="3" y="2" />
  </xsl:variable>

  <xsl:template match="/invoice">
    <xsl:copy-of select="
        product!my:applyDiscount(
            ., 
            let $sku := @sku return $discounts[@sku = $sku]) 
        => sum()" />
  </xsl:template>

  <xsl:function as="xs:double" name="my:applyDiscount">
    <xsl:param as="element(product)" name="product" /> 
    <xsl:param as="element(discount)?" name="discount" /> 
    <xsl:copy-of select="
      let $price    := $product/@price,
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