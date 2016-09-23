using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace CSharpXmlTransform
{
    class Program
    {
        static void Main(string[] args)
        {
            var input = @"..\..\invoice.xml";
         
            string contents = File.ReadAllText(input);
            var xDocument = XDocument.Parse(contents);
            string result = XPathInvoice2.Transform (xDocument);
            Console.WriteLine(result);
        }

        
    }

    class XPathInvoice1
    {
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
    }

    class XPathInvoice2
    {
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
    }
}
