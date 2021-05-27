//
//  GlobalDataController.swift
//

import Foundation

class GlobalDataController: AppController {
    var globalData: GlobalDto {
        get {
            return globalDataService.globalData
        }
    }
    
    override func update(_ command: Command, data: Any?) {
        switch command {
        case .cUpdateGlobalData:
            notifyObservers(.vUpdateGlobalData, data: data)
        default:
            super.update(command, data: data)
            break
        }
    }
}
