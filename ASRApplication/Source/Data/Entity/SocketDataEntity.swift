//SocketDataEntity.swift

import Foundation
import SwiftyJSON

class SocketDataEntity: BaseEntity {
    var code: Int!
    var httpStatus: Int!
    var msg: String!

    override public init(id: Int) {
        super.init(id: id)
    }

    required init(fromJson json: JSON!){
        code = json["code"].intValue
        httpStatus = json["httpStatus"].intValue
        msg = json["msg"].stringValue
        super.init(fromJson: json)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
