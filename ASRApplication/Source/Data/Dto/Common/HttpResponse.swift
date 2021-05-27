//RootClass.swift

import Foundation
import SwiftyJSON


public class HttpResponse : NSObject, NSCoding{

	var data : JSON!
    var meta : Meta!
    var global : GlobalDto!
    var pagination : Pagination!
    var total : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == JSON.null{
			return
		}
		data = json["data"]//		if dataJson != JSON.null{//			data = Data(fromJson: dataJson)//		}
		let metaJson = json["meta"]
		if metaJson != JSON.null{
			meta = Meta(fromJson: metaJson)
        }
        let globalJson = json["global"]
        if globalJson != JSON.null{
            global = GlobalDto(fromJson: globalJson)
        }
        let paginationJson = json["pagination"]
        if paginationJson != JSON.null{
            pagination = Pagination(fromJson: paginationJson)
        }
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if data != nil{
			dictionary["data"] = data
		}
		if meta != nil{
			dictionary["meta"] = meta.toDictionary()
        }
        if global != nil{
            dictionary["global"] = global.toDictionary()
        }
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required public init(coder aDecoder: NSCoder)
	{
        data = aDecoder.decodeObject(forKey: "data") as? JSON
        meta = aDecoder.decodeObject(forKey: "meta") as? Meta
        global = aDecoder.decodeObject(forKey: "global") as? GlobalDto
        pagination = aDecoder.decodeObject(forKey: "pagination") as? Pagination

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc public func encode(with aCoder:  NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if meta != nil{
			aCoder.encode(meta, forKey: "meta")
        }
        if global != nil{
            aCoder.encode(global, forKey: "global")
        }
        if pagination != nil{
            aCoder.encode(pagination, forKey: "pagination")
        }

	}

}
