//
//  SocketDataDto.swift
//

import Foundation
import SwiftyJSON

class SocketDataDto: BaseDto {
    var code: ErrorCode!
    var httpStatus: Int!
    var msg: String!

    override init() {
        super.init()
    }
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(code, forKey: "code")
        aCoder.encode(httpStatus, forKey: "httpStatus")
        aCoder.encode(msg, forKey: "msg")
    }

    public required init?(coder aDecoder: NSCoder) {
        self.code = aDecoder.decodeInteger(forKey: "code")
        self.httpStatus = aDecoder.decodeInteger(forKey: "httpStatus")
        self.msg = aDecoder.decodeObject(forKey: "msg") as! String
        super.init(coder: aDecoder)
    }

    required init(fromJson json: JSON!){
        code = json["code"].intValue
        httpStatus = json["httpStatus"].intValue
        msg = json["msg"].stringValue
        super.init(fromJson: json)
    }

    override func toDictionary() -> [String: Any] {
        var dictionary = super.toDictionary()
        dictionary["code"] = code
        dictionary["httpStatus"] = httpStatus
        dictionary["msg"] = msg
        return dictionary
    }
}
