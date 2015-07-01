import Foundation

class RSSItem {
	var title : NSString?
	var description : NSString?
	var link : NSString?
	var author : NSString?
	var guid : NSString?
	var date : NSString?
	
	init() {
		title = nil
		description = nil
		link = nil
		author = nil
		guid = nil
		date = nil
	}
	
	func setTitle( title : NSString? ) {
		self.title = title
	}
	
	func getTitle() -> NSString? {
		return title
	}
	
	func setDescription( description : NSString? ) {
		self.description = description
	}
	
	func getDescription() -> NSString? {
		return description
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
	
	func setDate( date : NSString? ) {
		self.date = date
	}
	
	func getDate() -> NSString? {
		return date
	}
}
