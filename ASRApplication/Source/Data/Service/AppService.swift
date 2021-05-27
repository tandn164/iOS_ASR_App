//
//  AppService.swift
//

import Foundation
import RxSwift

class AppService: BaseService, AppObserver {
    var globalDataRepository: GlobalDataRepository { return RepositoryFactory.globalDataRepository }
    
    func notifyObservers(_ command: Command, data: Any? = nil) {
        notifier.notifyObservers(command.rawValue, data: data)
    }
    
    public override func update(_ command: Int, data: Any?) {
        super.update(command, data: data)
        self.update(Command(rawValue: command)!, data: data)
    }
    
    func update(_ command: Command, data: Any?) {}

    func onError(error: Error) {
        print("error: \(error)")
    }

    func onCompleted() {
        
    }

//    func isError(data socketData: SocketData) -> Bool {
//        if let entity = socketData.data as? SocketDataEntity {
//            if entity.code < 0 {
//                return true
//            }
//        } else if let dto = socketData.data as? SocketDataDto {
//            if dto.code < 0 {
//                return true
//            }
//        } else {
//            fatalError("Unknown data type")
//        }
//        return false
//    }

    override func onReceiveSocketData(_ socketData: SocketData) {
        switch socketData.name {
        case SocketErrorDto.entityName:
            notifyObservers(.cSocketError, data: socketData.data)
        default:
            break
        }
    }
}
