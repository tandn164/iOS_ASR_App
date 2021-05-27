//
//  VersionDto.swift
//

import Foundation
import SwiftyJSON


class VersionDto: BaseDto {
    var version: Int?
    
    init(version: Int?) {
        super.init()
        self.version = version
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.version = aDecoder.decodeObject(forKey: "version") as? Int ?? -1
    }
    
    public required init(fromJson json: JSON!) {
        super.init(fromJson: json)
        version = json["version"].intValue
    }
    
//    public override func encode(with aCoder: NSCoder) {
//        super.encode(with: aCoder)
//        aCoder.encode(version, forKey: "ver")
//    }
    
    override func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["version"] = version
        return dictionary
    }
}
