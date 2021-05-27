//
//  TabCell.swift
//

import Foundation
import UIKit

class TabCell: XibView {
    let normalColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
    let activeColor = UIColor(red:1.00, green:0.13, blue:0.32, alpha:1.0)

    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var numberBackground: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    var count: String? {
        get {
            return numberLabel.text
        }
        set {
            numberLabel.text = newValue
            numberBackground.isHidden = (numberLabel.text ?? "").isEmpty
        }
    }
    
    var active: Bool {
        get {
//            return !activeView.isHidden
            return label.textColor == activeColor
        }
        set {
//            activeView.isHidden = !newValue
            label.textColor = newValue ? activeColor : normalColor
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
