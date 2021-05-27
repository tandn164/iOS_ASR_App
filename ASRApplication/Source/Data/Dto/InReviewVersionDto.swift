//
//  InReviewVersionEntity.swift
//

import Foundation
import SQLite
import SwiftyJSON

class InReviewVersionDto: BaseEntity {
    var android: Int!
    var ios: Int!

    init () {
        super.init(id: 0)
    }

    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(android, forKey: "android")
        aCoder.encode(ios, forKey: "ios")
    }
    public required init?(coder aDecoder: NSCoder) {
        self.android = aDecoder.decodeInteger(forKey: "android")
        self.ios = aDecoder.decodeInteger(forKey: "ios")
        super.init(coder: aDecoder)
    }

    required init(fromJson json: JSON!){
        android = json["android"].intValue
        ios = json["ios"].intValue
        super.init(id: 0)
    }

    override func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["android"] = android
        dictionary["ios"] = ios
        return dictionary
    }
}
