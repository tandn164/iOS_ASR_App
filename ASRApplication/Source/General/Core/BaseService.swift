//
//  BaseService.swift
//

import Foundation

open class BaseService: Observer {
    var notifier = Notifier.serviceNotifier
    
    public init() {
        Notifier.socketNoitfier.addObserver(self)
    }
    
    func notifyObservers(_ command: Int, data: Any? = nil) {
        notifier.notifyObservers(command, data: data)
    }
    
    public func addObserver(_ observer: Observer) {
        notifier.addObserver(observer)
    }
    
    public func removeObserver(_ observer: Observer) {
        notifier.removeObserver(observer)
    }
    
    open func update(_ command: Int, data: Any?) {
        switch command {
        case Constant.commandReceiveSocketData:
            onReceiveSocketData(data as! SocketData)
        default:
            break
        }
    }
    
    open func onReceiveSocketData(_ socketData: SocketData) {
        
    }
}
