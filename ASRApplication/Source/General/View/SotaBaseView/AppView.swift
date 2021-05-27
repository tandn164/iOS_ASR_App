//
//  AppView.swift
//

import Foundation
import UIKit

//extension UIView: Observer {
//    public func update(_ command: String, data: AnyObject?) {
//        self.update(Command(rawValue: command)!, data: data)
//    }
//    
//    func update(_ command: Command, data: AnyObject?) {
//    }
//}

extension UIView: AppObserver {
    @nonobjc
    func notifyObservers(_ command: Command, data: Any? = nil) {
        Notifier.viewNotifier.notifyObservers(command.rawValue, data: data)
    }
    
    @objc public func update(_ command: Command, data: Any?) {}

    func removeAllSubViews() {
        subviews.forEach({
            $0.removeFromSuperview()
        })
    }

    func removeAllGestureRecognizers() {
        gestureRecognizers?.forEach({removeGestureRecognizer($0)})
    }
    
}

class AppView: BaseView {
    var _notifier: Notifier?
    var notifier: Notifier! {
        set {
            _notifier = newValue
        }
        get {
            return _notifier ?? Notifier.viewNotifier
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    @objc func onUpdateLocale() {
        if let tableView = self as? UITableView {
            tableView.reloadData()
        }
        if let collectionView = self as? UICollectionView {
            collectionView.reloadData()
        }
        for subView: UIView in self.subviews {
            subView.onUpdateLocale()
        }
    }
}
