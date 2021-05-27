//
//  ListResponse.swift
//

import Foundation
import SwiftyJSON

class ListResponse<T: Serializable> {
    var data : [T]!
    var total : Int!
    
    init(fromJson json: JSON!){
        if json == JSON.null{
            return
        }
        
        data = [T]()
        let itemsArray = json["records"].arrayValue
        for itemJson in itemsArray{
            let value = T(fromJson: itemJson)
            data.append(value)
        }
        
        total = json["total"].intValue
    }
}
