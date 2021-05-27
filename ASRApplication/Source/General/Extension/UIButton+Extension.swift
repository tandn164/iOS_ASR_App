//UIButton+Extension.swift

import Foundation
import UIKit

extension UIButton {
    @IBInspectable var localizeTitle: String {
        set(value) {
            setTitle(value.localized, for: .normal)
        }
        get {
            return ""
        }
    }

    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = imageView?.image?.size,
              let text = titleLabel?.text,
              let font = titleLabel?.font
        else { return }

        titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageSize.width,
            bottom: -(imageSize.height + spacing),
            right: 0.0
        )

        let titleSize = text.size(withAttributes: [.font: font])
        imageEdgeInsets = UIEdgeInsets(
            top: -(titleSize.height + spacing),
            left: 0.0,
            bottom: 0.0,
            right: -titleSize.width
        )

        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        contentEdgeInsets = UIEdgeInsets(
            top: edgeOffset,
            left: 0.0,
            bottom: edgeOffset,
            right: 0.0
        )
    }

    public func preventRepeatedPresses(inNext seconds: Double = 1) {
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) { [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }

    override func onUpdateLocale() {
        super.onUpdateLocale()//        setTitle(LocalizationHelper.instance.localized(currentTitle), for: .normal)
    }
}

extension UITextView {
    func centerText() {
        textAlignment = .center
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
