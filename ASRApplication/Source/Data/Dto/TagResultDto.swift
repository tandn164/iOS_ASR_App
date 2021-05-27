//
//  TagResultDto.swift
//

import Foundation
import SwiftyJSON

class TagResultDto: BaseDto {
    var tags: [String]!

    init (tags: [String]) {
        self.tags = tags
        super.init()
    }
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(tags, forKey: "records")
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init(fromJson json: JSON!){
        tags = json["records"].arrayObject as? [String]
        super.init(fromJson: json)
    }

    override func toDictionary() -> [String: Any] {
        var dictionary = super.toDictionary()
        dictionary["records"] = tags
        return dictionary
    }
}
