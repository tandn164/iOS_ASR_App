//
//  Cache.swift
//

import Foundation
import SwiftyJSON

protocol Cache {
    func isCacheForEntity(name: String) -> Bool
    func save(_ json: JSON) -> AnyObject
}
