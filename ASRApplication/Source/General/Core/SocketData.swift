//
//  SocketData.swift
//

import Foundation

open class SocketData {
    open var name: String
    open var data: Serializable
    
    init(name: String, data: Serializable) {
        self.name = name
        self.data = data
    }
}
