//BaseView.swift

import Foundation
import UIKit


extension UIView {
    @objc public func viewWillAppear() {
        
    }
    
    @objc public func viewWillReappear() {
        
    }
    
    @objc public func viewDidAppear(_ data: Any? = nil) {
        Notifier.controllerNoitfier.addObserver(self)
        Notifier.viewNotifier.addObserver(self)
        Notifier.globalNotifier.addObserver(self)
    }
    
    @objc public func viewDidReappear(_ data: Any? = nil) {
        Notifier.controllerNoitfier.addObserver(self)
        Notifier.viewNotifier.addObserver(self)
        Notifier.globalNotifier.addObserver(self)
    }
    
    @objc public func viewWillDisappear() {
        Notifier.controllerNoitfier.removeObserver(self)
        Notifier.viewNotifier.removeObserver(self)
        Notifier.globalNotifier.removeObserver(self)
    }
    
    public func addObserver(_ observer: Observer) {
        Notifier.viewNotifier.addObserver(observer)
    }
    
    public func removeObserver(_ observer: Observer) {
        Notifier.viewNotifier.removeObserver(observer)
    }
    
    @nonobjc
    func notifyObservers(_ command: Int, data: AnyObject? = nil) {
        Notifier.viewNotifier.notifyObservers(command, data: data)
    }
    
    public func bringToFront() {
        self.superview?.bringSubviewToFront(self)
    }
    
    @objc public func forceConstraintToSuperView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraint to self
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.superview?.addConstraints([top, leading, trailing, bottom])
    }
}

class BaseView: UIView, ControllerManager {
    var views = [UIView]()
    private var controllers: [BaseController] = []
    
    override func viewWillAppear() {
        super.viewWillAppear()
        for view in views {
            view.viewWillAppear()
        }
    }
    
    override func viewWillReappear() {
        super.viewWillReappear()
        for view in views {
            view.viewWillReappear()
        }
    }
    
    override func viewDidAppear(_ data: Any? = nil) {
        for controller in controllers {
            controller.isPause = false
        }
        super.viewDidAppear(data)
        for view in views {
            view.viewDidAppear(data)
        }
    }
    
    override func viewDidReappear(_ data: Any? = nil) {
        for controller in controllers {
            controller.isPause = false
        }
        super.viewDidReappear(data)
        for view in views {
            view.viewDidReappear(data)
        }
    }
    
    override func viewWillDisappear()  {
        super.viewWillDisappear()
        for view in views {
            view.viewWillDisappear()
        }
        
        for controller in controllers {
            controller.isPause = true
        }
    }
    
    open func addView(_ view: UIView) {
        if views.firstIndex(of: view) == nil {
            views.append(view)
        }
    }
    
    open func onTouch(_ gesture: UIGestureRecognizer) -> Bool {
        return GestureUtil.processGesture(gesture, views: views)
    }
    
    func addController(_ controller: BaseController) {
        controllers.append(controller)
    }
    
    func releaseControllers() {
        for controller in controllers {
            Notifier.serviceNotifier.removeObserver(controller)
        }
    }
    
    deinit {
        releaseControllers()
    }
}

extension UIWindow {
    
    /// Fix for http://stackoverflow.com/a/27153956/849645
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
