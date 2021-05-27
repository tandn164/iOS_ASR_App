//UIAppLabel.swift

import Foundation
import UIKit

extension UILabel {
    @IBInspectable var spacing: CGFloat {
        get {
            return 0
        }
        set {
            let attributedString = NSMutableAttributedString(string: text ?? "")
            if text?.count ?? 0 > 0 {
                attributedString.addAttribute(NSAttributedString.Key.kern, value: newValue, range: NSMakeRange(0, text!.count - 1))
            }
            self.attributedText = attributedString
        }
    }
    
    @IBInspectable var localizeText: String {
        set(value) {
            self.text = value.localized
        }
        get {
            return ""
        }
    }
    
    
    @IBInspectable var isCapitalizeFirstLetter: Bool {
        set(value) {
            self.text = self.text?.capitalizingFirstLetter()
        }
        get {
            return false
        }
    }
    
}
