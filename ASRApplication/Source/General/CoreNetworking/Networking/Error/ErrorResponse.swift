//
//  RegisterRequest.swift
//

import Foundation
import ObjectMapper

class ErrorResponse: Mappable {
    var statusCode: String?
    var statusMessage: String?
    var success: Bool? = false
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        statusCode <- map["messageCode"]
        statusMessage <- map["message"]
        success <- map["success"]
    }
}
