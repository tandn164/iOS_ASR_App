//
//  SocketResponse.swift
//

import Foundation
import SwiftyJSON


class SocketResponse : NSObject, NSCoding{
    
    var data : JSON!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json == JSON.null{
            return
        }
        data = json["data"]
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
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        data = aDecoder.decodeObject(forKey: "data") as? JSON
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder:  NSCoder)
    {
        if data != nil{
            aCoder.encode(data, forKey: "data")
        }
        
    }
    
}
