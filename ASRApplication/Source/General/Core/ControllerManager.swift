//
//  ControllerManager.swift
//

import Foundation

public protocol ControllerManager {
    func addController(_ controller: BaseController)
    func releaseControllers()
}
