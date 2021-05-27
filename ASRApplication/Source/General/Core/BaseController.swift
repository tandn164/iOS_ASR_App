//BaseController.swift

import Foundation

open class BaseController: Observer {
    var notifier = Notifier.controllerNoitfier

    var isPause = false
    
    init() {
        Notifier.serviceNotifier.addObserver(self)
    }
    
    func notifyObservers(_ command: Int, data: Any? = nil) {
        if !isPause {
            notifier.notifyObservers(command, data: data)
        }
    }
    
    public func addObserver(_ observer: Observer) {
        notifier.addObserver(observer)
    }
    
    public func removeObserver(_ observer: Observer) {
        notifier.removeObserver(observer)
    }
    
    public func update(_ command: Int, data: Any?) {}
}
