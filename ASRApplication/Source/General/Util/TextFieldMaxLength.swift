//
//  TextFieldMaxLength.swift
//

import Foundation
import UIKit

private var maxLengths = [UITextField: Int]()

extension UITextField {

    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControl.Event.editingChanged
            )
        }
    }
    
    @IBInspectable var localizePlaceholder: String {
        set(value) {
            self.placeholder = value.localized
        }
        get {
            return ""
        }
    }

    @objc func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
                return
        }

        let selection = selectedTextRange
        text = prospectiveText.substring(to: prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength))
        selectedTextRange = selection
    }
}
