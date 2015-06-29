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

//Representations of the parse process state
enum States {
    case INIT
    case ITEM
    case TITLE
    case DESCRIPTION
    case LINK
	case AUTHOR
	case GUID
    case DATE
}

//Constants
let TAG_ITEM : NSString = "item"
let TAG_TITLE : NSString = "title"
let TAG_DESCRIPTION : NSString = "description"
let TAG_LINK : NSString = "link"
let TAG_AUTHOR : NSString = "author"
let TAG_GUID : NSString = "guid"
let TAG_DATE : NSString = "pubDate"

class RSSItem {
    var title : NSString?
    var date : NSString?
    var link : NSString?
	var author : NSString?
	var guid : NSString?
    
    init() {
        title = nil
        date = nil
        link = nil
		author = nil
		guid = nil
    }
    
    func setTitle( title : NSString? ) {
        self.title = title
    }
    
    func getTitle() -> NSString? {
        return title
    }
    
    func setDate( date : NSString? ) {
        self.date = date
    }
    
    func getDate() -> NSString? {
        return date
    }
    
    func setLink( link : NSString? ) {
        self.link = link
    }
    
    func getLink() -> NSString? {
        return link
    }
	
	func setAuthor( author: NSString? ) {
		self.author = author
	}
	
	func getAuthor() -> NSString? {
		return author
	}
	
	func setGUID( guid: NSString? ) {
		self.guid = guid
	}
	
	func getGUID() -> NSString? {
		return guid
	}
}

class RSSXMLDelegate : NSObject, NSXMLParserDelegate {
    var rssItemsList = [RSSItem]()
    var temporaryRSSItem : RSSItem?
    var state : States = States.INIT
    
    func getItemsList() -> [RSSItem] {
        return rssItemsList
    }
    
    func parserDidStartDocument( xmlParser: NSXMLParser ) {
        state = States.INIT
        temporaryRSSItem = nil
    }
    
    func parserDidEndDocument( _parser: NSXMLParser) {
        state = States.INIT
        temporaryRSSItem = nil
    }
    
    func parser( _parser: NSXMLParser, didStartElement elementName: String, namespaceURI namespaceURI: String?, qualifiedName qualifiedName: String?,attributes attributeDict: [NSObject : AnyObject]) {
        
        /*Standard structure:
         *<item>
         *  <title></title>
         *  <description></description>
         *  <link></link>
		 *  <author></author>
		 *  <guid></guid>
         *  <pubDate></pubDate>
         *</item>*/
        
        //Valid states
        // Start = INIT
        // INIT --> ITEM
        // ITEM --> TITLE
        // TITLE --> DESCRIPTION (Do nothing)
        // TITLE OR DESCRIPTION --> LINK
        // LINK --> DATE
        
        switch( elementName ) {
            case TAG_ITEM:
                if( state == States.INIT || state == States.TITLE || state == States.DESCRIPTION ||
					state == States.LINK || state == States.DATE ) {
                    state = States.ITEM
                    
                    if let rssItem = temporaryRSSItem {
                        rssItemsList.append( rssItem )
                    }
                    
                    temporaryRSSItem = RSSItem()
                }
                break
            case TAG_TITLE:
                if( state == States.ITEM ) {
                    state = States.TITLE
                }
                break
            case TAG_DESCRIPTION:
                if( state == States.TITLE ) {
                    state = States.DESCRIPTION
                }
				break;
            case TAG_LINK:
                if( state == States.TITLE || state == States.DESCRIPTION ) {
                    state = States.LINK
                }
                break
			case TAG_AUTHOR:
				//if( state == States.LINK ) {
				//	state = States.AUTHOR
				//}
				break
			case TAG_GUID:
				break
            case TAG_DATE:
                if( state == States.LINK ) {
                    state = States.DATE
                }
                break
            default:
                //Do nothing
                break
        }
    }
    
    func parser( _parser: NSXMLParser, foundCharacters string: String? ) {
        //Get the content of the XML node
        var title : NSString?
        var link : NSString?
        var date : NSString?
        
        switch( state ) {
        case States.TITLE:
            //Get the title
            if let tempItem = temporaryRSSItem {
                title = tempItem.getTitle()
                if let t = title {
                    if let s = string {
                        title = t.stringByAppendingString( s )
						if let t_new = title {
							title = t_new.stringByReplacingOccurrencesOfString( "\n", withString: "" )
    	                    tempItem.setTitle( title )
						}
                    }
                } else {
                    if let s = string {
                        title = s
                        tempItem.setTitle( title )
                    }
                }
            }
            break
            
        case States.LINK:
            //Get the url for the link to the original site
            if let tempItem = temporaryRSSItem {
                link = tempItem.getLink()
                if( link == nil ) {
                    link = string
                    if let tempItem = temporaryRSSItem {
                        tempItem.setLink( link )
                    }
                }
            }
            break
            
        case States.DATE:
            //Get the date for the post
            if let tempItem = temporaryRSSItem {
                date = tempItem.getDate()
                if( date == nil ) {
                    date = string
           
                    if let d = date {
                        tempItem.setDate( d )
                    }
                }
            }
            break
            
        default:
            break
        }
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// CommandLineRSS
// Simple RSS Reader made with Swift
// fabian (at) fabianschneider.org
// GPL V2
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

var rssURL : NSURL? = NSURL( string: "http://www.fernuni-hagen.de/universitaet/include/aktuelles_rss.xml" )
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
                var title : NSString?
                var link : NSString?
                var date : NSString?
                
                if let title = item.getTitle() {
                    println( title )
                }
                
                if let link = item.getLink() {
                    println( link )
                }
                
                if let date = item.getDate() {
                    println( date )
                }
				
				println()
            }
        }
    }
}

