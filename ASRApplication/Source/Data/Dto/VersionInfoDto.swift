//
//  VersionInfoDto.swift
//

import Foundation
import SwiftyJSON

class VersionInfoDto: BaseDto {
    var requiredVersion: Int!
    var isForceUpdated: Int!
    var latestVersion: Int!
    var msg: String!

    init (requiredVersion: Int, isForceUpdated: Int, latestVersion: Int, msg: String) {
        self.requiredVersion = requiredVersion
        self.isForceUpdated = isForceUpdated
        self.latestVersion = latestVersion
        self.msg = msg
        super.init()
    }
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(requiredVersion, forKey: "requiredVersion")
        aCoder.encode(isForceUpdated, forKey: "isForceUpdated")
        aCoder.encode(latestVersion, forKey: "latestVersion")
        aCoder.encode(msg, forKey: "msg")
    }

    public required init?(coder aDecoder: NSCoder) {
        self.requiredVersion = aDecoder.decodeInteger(forKey: "requiredVersion")
        self.isForceUpdated = aDecoder.decodeInteger(forKey: "isForceUpdated")
        self.latestVersion = aDecoder.decodeInteger(forKey: "latestVersion")
        self.msg = aDecoder.decodeObject(forKey: "msg") as! String
        super.init(coder: aDecoder)
    }

    required init(fromJson json: JSON!){
        requiredVersion = json["requiredVersion"].intValue
        isForceUpdated = json["isForceUpdated"].intValue
        latestVersion = json["latestVersion"].intValue
        msg = json["msg"].stringValue
        super.init(fromJson: json)
    }

    override func toDictionary() -> [String: Any] {
        var dictionary = super.toDictionary()
        dictionary["requiredVersion"] = requiredVersion
        dictionary["isForceUpdated"] = isForceUpdated
        dictionary["latestVersion"] = latestVersion
        dictionary["msg"] = msg
        return dictionary
    }
}
