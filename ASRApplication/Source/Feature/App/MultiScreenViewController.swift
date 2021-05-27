//
//  MultiScreenViewController.swift
//

import Foundation
import UIKit

class MultiScreenViewController: AppViewController {
    
    @IBOutlet weak var screenContainer: UIView!
    
    var screenFrame: CGRect {
        get {
            return screenContainer.frame
        }
    }
    
    var currentScreen: UIView? {
        get {
            return screenContainer.subviews.last
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @nonobjc
    override func update(_ command: Command, data: Any?) {
        switch command {
        case .vShowLastScreen:
            self.showLastScreen(data)
        default:
            super.update(command, data: data)
        }
    }
    
    
    func showLastScreen(_ data: Any? = nil) {
        let screenCount = screenContainer.subviews.count
        screenContainer.subviews[screenCount - 1].viewWillDisappear()
        removeView(screenContainer.subviews[screenCount - 1])
        screenContainer.subviews[screenCount - 1].removeFromSuperview()
        
        screenContainer.subviews[screenCount - 2].isHidden = false
        screenContainer.subviews[screenCount - 2].viewDidReappear(data)
    }
    
    func addScreen(_ screen: UIView, data: Any? = nil) {
        screenContainer.subviews.forEach({ $0.isHidden = true })
        screenContainer.addSubview(screen)
        addView(screen) // for data and event
        screen.viewDidAppear(data)
    }
    
    func changeScreen(_ screen: UIView, data: Any? = nil, reappear: Bool = false) {
        screenContainer.subviews.forEach({
            $0.viewWillDisappear()
            $0.removeFromSuperview()
            self.removeView($0)
        })
        screenContainer.addSubview(screen)
        addView(screen) // for data and event
        if reappear {
            screen.viewDidReappear()
        } else {
            screen.viewDidAppear(data)
        }
    }
}
