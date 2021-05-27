//
//  Serializable.swift
//

import Foundation
import SwiftyJSON

public protocol Serializable: class {
    var id: DataIdType! { get set }

    static var entityName: String {
        get
    }
    
    static var pluralName: String {
        get
    }
    
    init(fromJson json: JSON?)
    
    func toDictionary() -> Dictionary<String, Any>
}
