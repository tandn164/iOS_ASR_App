//
//  GlobalDataService.swift
//

import Foundation

class GlobalDataService: AppService {
    override init() {
        super.init()
        Notifier.repositoryNotifier.addObserver(self)
    }
    
    var globalData: GlobalDto {
        get {
            return globalDataRepository.globalData
        }
    }
    
    override func update(_ command: Command, data: Any?) {
        switch command {
        case .sUpdateGlobalData:
            onReceiveGlobalData(data as! GlobalDto)
        default:
            super.update(command, data: data)
            break
        }
    }
    
    open func onReceiveGlobalData(_ data: GlobalDto) {
        globalDataRepository.saveGlobalData(data)
        notifyObservers(.cUpdateGlobalData, data: data)
    }

    override func onReceiveSocketData(_ socketData: SocketData) {
        switch socketData.name {
        case GlobalDto.entityName:
            let globalData = socketData.data as! GlobalDto
            onReceiveGlobalData(globalData)
        default:
            break
        }
    }
}
