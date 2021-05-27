//
//  TextUtil.swift
//

import Foundation
import UIKit

enum FontStyle {
    case
    bold,
    medium,
    regular
}

class TextUtil {
    static func createFont(style: FontStyle, size: CGFloat) -> UIFont {
        switch style {
        case .bold:
            return UIFont(name: "FiraSans-Bold", size: size)!
//                UIFont.boldSystemFont(ofSize: size)
        case .regular, .medium:
            return UIFont(name: "FiraSans-Regular", size: size)!
//                UIFont.systemFont(ofSize: size)
        }
//        return UIFont.systemFont(ofSize: size)
    }

    static func make(content: String, style: FontStyle = .regular, size: CGFloat, lineHeight: CGFloat? = nil, color: UIColor = UIColor.black) -> NSAttributedString {
        let text = NSMutableAttributedString(string: content)
        let range = NSRange(location: 0, length: text.length)
        text.addAttribute(NSAttributedString.Key.font, value: TextUtil.createFont(style: style, size: size), range: range)
        if let lineHeight = lineHeight {
            let paragrapphStyle = NSMutableParagraphStyle()
            paragrapphStyle.lineSpacing = lineHeight - size
            text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapphStyle, range: range)
        }
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return text
    }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
