//
//  Toast+Extension.swift
//

import Foundation

extension Toast {
    static func overlayToastWith(text: String?, delay: TimeInterval = 0, duration: TimeInterval = Delay.short) {
        if text != ToastCenter.default.currentToast?.text {
            Toast(text: text, delay: delay, duration: duration).show()
        }
    }
    
    static func overlayToastWith(attributedText: NSAttributedString?, delay: TimeInterval = 0, duration: TimeInterval = Delay.short) {
        if attributedText?.string != ToastCenter.default.currentToast?.attributedText?.string {
            Toast(attributedText: attributedText, delay: delay, duration: duration).show()
        }
    }
}
