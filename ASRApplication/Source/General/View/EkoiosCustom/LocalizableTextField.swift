//
//  LocalizableTextField.swift
//

import UIKit

class LocalizableTextField: SkyFloatingLabelTextField {

    private var localizeKey: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localizeKey = placeholder
        placeholder = localizeKey
    }
    
    override public var placeholder:String?  {
        set (newValue) {
            localizeKey = newValue
            super.placeholder = LocalizationHelper.instance.localized(localizeKey)
        }
        get {
            return super.placeholder
        }
    }
    
    override func onUpdateLocale() {
        super.onUpdateLocale()
        placeholder = localizeKey
    }

}
