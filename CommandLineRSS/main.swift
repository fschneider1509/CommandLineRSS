import Foundation

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// CommandLineRSS
// Simple RSS Reader made with Swift
// fabian (at) fabianschneider.org
// GPL V2
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//Parsing command line arguments

if( Process.argc == 2 ) {
	
	//Get String from argument
	var urlString : String = Process.arguments[ 1 ]

	var rssURL : NSURL? = NSURL( string: urlString )
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
} else {
	println( "Missing Argument!" )
	println( "CommandLineRSS $URL_TO_RSSFEED" )
	println( "Example:" )
	println( "\t CommandLineRSS http://www.faz.net/rss/aktuell/" )
}

