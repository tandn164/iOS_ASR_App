//
//  SocketRepository.swift
//

import Foundation
import SwiftyJSON

class SocketRepository {
    let notifier = Notifier.socketNoitfier
    
    var socketRequest: SocketRequest!
    var dtoTypes = [BaseDto.entityName: BaseDto.self]
    var entityTypes = [BaseEntity.entityName: BaseEntity.self]
    
    init(namespace: String) {
        socketRequest = createSocketRequest(namespace: namespace)
    }

    func createSocketRequest(namespace: String) -> SocketRequest {
        return SocketRequest(namespace: namespace)
    }
    
    open func connect(roomId: DataIdType) {
        socketRequest.connect(roomId: roomId)
    }
    
    open func disconnect() {
        socketRequest.disconnect()
    }
    
    open func joinRoom(roomId: DataIdType) {
        socketRequest.joinRoom(roomId)
    }

    open func connectIfNeed() {
        socketRequest.connectIfNeed()
    }

    open func addDataType(_ type: BaseDto.Type) {
        socketRequest.addDataEvent(type)
    }
    
    open func addDataType(_ type: BaseEntity.Type) {
        socketRequest.addDataEvent(type)
    }
    
    open func send(_ data: Serializable) -> Bool {
        return socketRequest.send(data)
    }
}
