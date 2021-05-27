//
//	Pagination.swift
//

import Foundation
import SwiftyJSON


class Pagination : NSObject, NSCoding{

	var maxPage : Int!
	var page : Int!
	var pageSize : Int!
	var sort : String!
    var before: String!
    var after: String!
    var previous: String!
    var next: String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == JSON.null{
			return
		}
		maxPage = json["maxPage"].intValue
		page = json["page"].intValue
		pageSize = json["pageSize"].intValue
        sort = json["sort"].stringValue
        before = json["before"].stringValue
        after = json["after"].stringValue
        previous = json["previous"].stringValue
        next = json["next"].stringValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if maxPage != nil{
			dictionary["maxPage"] = maxPage
		}
		if page != nil{
			dictionary["page"] = page
		}
		if pageSize != nil{
			dictionary["pageSize"] = pageSize
		}
		if sort != nil {
			dictionary["sort"] = sort
        }
        if before != nil {
            dictionary["before"] = sort
        }
        if after != nil {
            dictionary["after"] = sort
        }
        if previous != nil {
            dictionary["previous"] = sort
        }
        if next != nil {
            dictionary["next"] = sort
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         maxPage = aDecoder.decodeObject(forKey: "maxPage") as? Int
         page = aDecoder.decodeObject(forKey: "page") as? Int
         pageSize = aDecoder.decodeObject(forKey: "pageSize") as? Int
        sort = aDecoder.decodeObject(forKey: "sort") as? String
        before = aDecoder.decodeObject(forKey: "before") as? String
        after = aDecoder.decodeObject(forKey: "after") as? String
        previous = aDecoder.decodeObject(forKey: "previous") as? String
        next = aDecoder.decodeObject(forKey: "next") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder:  NSCoder)
	{
		if maxPage != nil{
			aCoder.encode(maxPage, forKey: "maxPage")
		}
		if page != nil{
			aCoder.encode(page, forKey: "page")
		}
		if pageSize != nil{
			aCoder.encode(pageSize, forKey: "pageSize")
		}
		if sort != nil{
			aCoder.encode(sort, forKey: "sort")
        }
        if before != nil{
            aCoder.encode(sort, forKey: "before")
        }
        if after != nil{
            aCoder.encode(sort, forKey: "after")
        }
        if previous != nil{
            aCoder.encode(sort, forKey: "previous")
        }
        if next != nil{
            aCoder.encode(sort, forKey: "next")
        }

	}

}
