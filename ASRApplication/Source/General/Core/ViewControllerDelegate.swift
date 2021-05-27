//
//  ViewControllerDelegate.swift
//
//

import Foundation
import UIKit

@objc protocol ViewControllerDelegate {
    @objc optional func viewControllerDidDismiss(sender: UIViewController, data: [String: Any])
}
