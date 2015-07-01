import Foundation

//Representations of the parse process states
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
	
	func parser( _parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName: String?,attributes attributeDict: [NSObject : AnyObject]) {
		
		/*Standard structure:
		*<item>
		*  <title></title>
		*  <description></description>
		*  <link></link>
		*  <author></author>
		*  <guid></guid>
		*  <pubDate></pubDate>
		*</item>*/
		
		/*Valid states
		*  Start = INIT
		*  INIT | TITLE | DESCRIPTION | LINK | DATE --> ITEM
		*  ITEM --> TITLE
		*  TITLE --> DESCRIPTION
		*  TITLE OR DESCRIPTION --> LINK
		*  LINK --> DATE */
		
		switch( elementName ) {
		case TAG_ITEM:
			if( state == States.INIT || state == States.TITLE || state == States.DESCRIPTION ||
				state == States.LINK || state == States.DATE || state == States.AUTHOR ||
				state == States.GUID ) {
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
			if( state == States.LINK || state == States.TITLE ||
				state == States.DESCRIPTION ) {
					state = States.AUTHOR
			}
			break
		case TAG_GUID:
			if( state == States.LINK || state == States.TITLE ||
				state == States.DESCRIPTION || state == States.AUTHOR ) {
					state = States.GUID
			}
			break
		case TAG_DATE:
			if( state == States.LINK || state == States.TITLE ||
				state == States.DESCRIPTION || state == States.AUTHOR ||
				state == States.GUID ) {
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
		var description : NSString?
		var link : NSString?
		var author : NSString?
		var guid : NSString?
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
		case States.DESCRIPTION:
			//Get the description of the post
			if let tempItem = temporaryRSSItem {
				description = tempItem.getDescription()
				if let d = description {
					if let s = string {
						description = d.stringByAppendingString( s )
						tempItem.setDescription( description )
					}
				} else {
					if let s = string {
						tempItem.setDescription( s )
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
			
		case States.AUTHOR:
			//Get the author of the post
			if let tempItem = temporaryRSSItem {
				author = tempItem.getAuthor()
				if( author == nil ) {
					author = string
					
					if let a = author {
						tempItem.setAuthor( a )
					}
				}
			}
			break
			
		case States.GUID:
			//Get the guid of the post
			if let tempItem = temporaryRSSItem {
				guid = tempItem.getGUID()
				if( guid == nil ) {
					guid = string
					
					if let g = guid {
						tempItem.setGUID( g )
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

