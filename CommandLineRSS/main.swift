import Foundation

//########################################################
// ToDo-List:
//      - Private / Public / etc.
//      - Extend RSSXMLDelegate with Map/List for RSS-Item
//        objects
//      - Check warnings
//      - Check if "if let x..." also works with the 
//        !-operator
//########################################################


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// CommandLineRSS
// Simple RSS Reader made with Swift
// fabian (at) fabianschneider.org
// GPL V2
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

var rssURL : NSURL? = NSURL( string: "http://blog.fefe.de/rss.xml" )
var rssItems = [RSSItem]()

if let url = rssURL {
    var xmlParser : NSXMLParser? = NSXMLParser( contentsOfURL: rssURL )
    var xmlDelegate : RSSXMLDelegate = RSSXMLDelegate()

   
    if let parser = xmlParser {
        parser.delegate = xmlDelegate

        if( !parser.parse() ) {
            //Error while parsing the XML file
            println( "Error while parsing the XML file" )
        } else {
            rssItems = xmlDelegate.getItemsList()
            
            for item in rssItems {
				
                if let title = item.getTitle() {
                    println( title )
                }
				
				if let description = item.getDescription() {
					println( description )
				}
				
                if let link = item.getLink() {
                    println( link )
                }
				
				if let author = item.getAuthor() {
					println( author )
				}
				
				if let guid = item.getGUID() {
					println( guid )
				}
				
                if let date = item.getDate() {
                    println( date )
                }
				
				println()
            }
        }
    }
}

