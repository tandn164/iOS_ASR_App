//
//  LocalizableButton.swift
//

import UIKit

class LocalizableButton: UIButton {
    
    private var localizeKey: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localizeKey = currentTitle
        setTitle(localizeKey, for: .normal)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        localizeKey = title
        super.setTitle(LocalizationHelper.instance.localized(localizeKey), for: state)
    }
    
    override func onUpdateLocale() {
        super.onUpdateLocale()
        setTitle(localizeKey, for: .normal)
    }

}
