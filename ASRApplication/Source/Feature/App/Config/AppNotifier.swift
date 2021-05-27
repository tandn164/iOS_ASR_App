//
//  AppNotifier.swift
//

import Foundation

extension Notifier {
    func notifyObservers(_ command: Command, data: Any? = nil) {
        notifyObservers(command.rawValue, data: data)
    }
}
