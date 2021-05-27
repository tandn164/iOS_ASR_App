//
//  Observer+Extension.swift
//

import UIKit

public protocol AppObserver: class, Observer {
    func update(_ command: Command, data: Any?)
}

extension AppObserver {
    public func update(_ command: Int, data: Any?) {
        self.update(Command(rawValue: command)!, data: data)
    }
}

extension AppObserver where Self: UIView {
    public func update(_ command: Int, data: Any?) {
        DispatchQueue.main.async {
            self.update(Command(rawValue: command)!, data: data)
        }
    }
}
