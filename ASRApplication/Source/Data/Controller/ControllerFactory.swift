//
//  ControllerFactory.swift
//

import Foundation

class ControllerFactory {
    static let globalDataController = GlobalDataController()
    static let transcriptionController = TranscriptionController()
    
    static func createController<T: AppController>(type: T.Type, for controllerManager: ControllerManager) -> T {
        let controller = T()
        controllerManager.addController(controller)
        return controller
    }
}
