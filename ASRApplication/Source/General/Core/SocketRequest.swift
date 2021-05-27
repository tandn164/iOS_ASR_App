//
//  SocketRequest.swift
//

import Foundation
import SocketIO
import SwiftyJSON

public class SocketRequest {
    let notifier = Notifier.socketNoitfier
    var socket: SocketIOClient!
    var socketManager: SocketManager!
    var roomId: DataIdType!
    var namespace: String
    
    init(namespace: String) {
        self.namespace = namespace
        createSocket()
    }

    func createSocketConfig() -> SocketIOClientConfiguration {
        let connectParams = SocketIOClientOption.connectParams(createConnectParams())
        let config: SocketIOClientConfiguration = [
            .log(false),
            .forcePolling(true),
            connectParams,
            .compress,
        ]
        return config
    }

    func createConnectParams() -> [String: String] {
        return [:]
    }

    open func connectIfNeed() {
        if socket.status != .connected && socket.status != .connecting {
            createSocket()
        }
    }
    
    open func connect(roomId: DataIdType) {
        self.roomId = roomId
        createSocket()
    }

    func createSocket() {
        let url = URL(string: AppConfig.socketServer)!
        socketManager = SocketManager(socketURL: url, config: createSocketConfig())
        socket = socketManager.socket(forNamespace: namespace)
        
        socket.on("connect", callback: { [weak self] data, ack in
            self?.joinRoom(self?.roomId ?? 20)
        })

        socket.on("notifications", callback: { data, ack in
            print("Socket notifications: \(data)")
//            let json = JSON(data[0])
//            let dto = LiveNotificationDto(fromJson: json)
//            self?.notifier.notifyObservers(Constant.commandReceiveSocketData, data: SocketData(name: LiveNotificationDto.entityName, data: dto))
        })
        
        socket.on("error", callback: {
            data, ack in
            print("Socket error: \(data)")
        })

        socket.on("socketError", callback: {
            [unowned self] data, ack in
            let json = JSON(data[0])
            print("Data from socket: socketError => \(String(describing: json.rawString())) --")
            let dto = SocketErrorDto(fromJson: json)
            self.notifier.notifyObservers(Constant.commandReceiveSocketData, data: SocketData(name: SocketErrorDto.entityName, data: dto))
        })

        addDataEvents()
        socket.connect()
    }

    open func disconnect() {
        socket.disconnect()
    }
    
    open func joinRoom(_ roomId: DataIdType) {
        self.roomId = roomId
        if socket.status == .connected {
            self.socket.emit("join-room", roomId)
        }
    }

    var entityEvents: [
        (
            type: BaseEntity.Type,
            callback: (([Any], SocketAckEmitter) -> Void)
        )
        ] = []

    var dtoEvents: [
        (
            type: BaseDto.Type,
            callback: (([Any], SocketAckEmitter) -> Void)
        )
        ] = []

    func addDataEvent(_ type: BaseEntity.Type) {
        entityEvents.append((type: type, callback: {
            [unowned self] data, ack in
            let json = JSON(data[0])
            print("Data from socket: \(type.self.entityName) => \(String(describing: json.rawString())) --")
            let entity = type.init(fromJson: json)
            self.notifier.notifyObservers(Constant.commandReceiveSocketData, data: SocketData(name: type.self.entityName, data: entity))
        }))
    }

    
    func addDataEvent(_ type: BaseDto.Type) {
        dtoEvents.append((type: type, callback: {
            [unowned self] data, ack in
            let json = JSON(data[0])
            print("Data from socket: \(type.self.entityName) => \(String(describing: json.rawString())) --")
            let dto = type.init(fromJson: json)
            self.notifier.notifyObservers(Constant.commandReceiveSocketData, data: SocketData(name: type.self.entityName, data: dto))
        }))
    }

    func addDataEvents() {
        for event in entityEvents {
            socket.on(event.type.self.entityName, callback: event.callback)
        }
        for event in dtoEvents {
            socket.on(event.type.self.entityName, callback: event.callback)
        }
    }
    
    open func send(_ data: Serializable) -> Bool {
        if socket.status != .connected {
            return false
        }
        print("Send over socket: \(type(of: data).entityName) \(JSON(data.toDictionary()).rawString() ?? "")")
        socket.emit(type(of: data).entityName, data.toDictionary())
        return true
    }
}
