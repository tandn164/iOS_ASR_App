//
//    Meta.swift
//

import Foundation
import SwiftyJSON

class Meta : NSObject, NSCoding, Error {

    var code : Int!
    var masterdataVersion : Int!
    var serverTime : Int!
    var msg: String!
    var httpCode: Int!
    
    var extraInfo: ExtraInfor!
    var errorCode: String!
 
    // Just a wrapper
    var wrappedCode: Int! {
        return code
    }


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json == JSON.null{
            return
        }
        code = json["code"].intValue
        masterdataVersion = json["masterdataVersion"].intValue
        serverTime = json["serverTime"].intValue
        msg = json["msg"].stringValue
        errorCode = json["errorCode"].stringValue
        extraInfo = ExtraInfor(fromJson: json["extraInfo"])
    }

    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if code != nil{
            dictionary["code"] = code
        }
        if masterdataVersion != nil{
            dictionary["masterdataVersion"] = masterdataVersion
        }
        if serverTime != nil{
            dictionary["serverTime"] = serverTime
        }
        if msg != nil{
            dictionary["msg"] = msg
        }
        if errorCode != nil{
            dictionary["errorCode"] = errorCode
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         code = aDecoder.decodeObject(forKey: "code") as? Int
         masterdataVersion = aDecoder.decodeObject(forKey: "masterdataVersion") as? Int
         serverTime = aDecoder.decodeObject(forKey: "serverTime") as? Int
        msg = aDecoder.decodeObject(forKey: "msg") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder:  NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if masterdataVersion != nil{
            aCoder.encode(masterdataVersion, forKey: "masterdataVersion")
        }
        if serverTime != nil{
            aCoder.encode(serverTime, forKey: "serverTime")
        }
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }

    }
}

extension Meta: LocalizedError {
    public var errorDescription: String? {
//        return NSLocalizedString(msg ?? "", comment: "")
        if let error = extraInfo {
            if error.key == "name" {
                return String(format: errorCode.localized, error.value.localized)
            }
            else{
                return String(format: errorCode.localized, error.value)
            }
        }
        else{
            return NSLocalizedString(errorCode ?? "", comment: "")
        }
    }
}

class ExtraInfor: NSObject {
    var key: String!
    var value: String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json == JSON.null{
            return
        }
        key = json["key"].stringValue
        value = json["value"].stringValue
        
    }
}
