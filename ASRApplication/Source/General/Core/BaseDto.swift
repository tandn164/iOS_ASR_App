//
//  BaseDto.swift
//
//

import Foundation
import SwiftyJSON

class BaseDto: NSObject, NSCoding, Serializable {
    open var id: DataIdType!

    public static var entityName: String {
        get {
            var name = String(describing: self)
            let lowercase = String(name[name.startIndex]).lowercased()
            name.replaceSubrange(name.startIndex...name.startIndex, with: lowercase)
            if name.hasSuffix("Dto") {
                name = name.substring(to: name.index(name.endIndex, offsetBy: -"Dto".count))
            }
            return name
        }
    }
    
    public static var pluralName: String {
        get {
            return entityName + "s"
        }
    }
    
    open func encode(with aCoder: NSCoder) {
    }
    
    override init() {}
    
    public required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! DataIdType
    }
    
    public required init(fromJson json: JSON?) {
        if let value = json?["id"].object as? DataIdType {
            self.id = value
        }
    }

    public func toDictionary() -> [String : Any] {
        let dictionary = [String: Any]()
        return dictionary
    }

    func toString() -> String {
        let json = JSON(toDictionary())
        return json.rawString()!
    }
}
