//
//  Observer.swift
//

import Foundation

public protocol Observer: class {
    func update(_ command: Int, data: Any?)
}
