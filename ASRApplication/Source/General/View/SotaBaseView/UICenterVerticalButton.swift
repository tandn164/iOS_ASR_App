//
//  UICenterVerticalself.swift
//

import UIKit

class UICenterVerticalButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.centerVertically()
    }
}

private extension UICenterVerticalButton {
    func centerVertically() {
        guard let imageSize: CGSize = self.imageView?.image?.size,
            let labelText = self.titleLabel?.text
            else {
                return
            }
        let spacing: CGFloat = 2.0
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: labelText)
        let titleSize = labelString.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): self.titleLabel!.font]))
        self.imageEdgeInsets = UIEdgeInsets.init(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets.init(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
