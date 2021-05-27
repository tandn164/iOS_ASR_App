//
//  UIHeaderBar.swift
//

import Foundation
import UIKit

class HeaderBar: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBInspectable var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }

    func initSubviews() {
        initShadow()
    }

    func initShadow() {
        let color = UIColor(red: 0.266, green: 0.266, blue: 0.266, alpha: 1)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = Float(0.05)
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 30


//        let color = UIColor(red: 0.266, green: 0.266, blue: 0.266, alpha: 1)
//        self.layer.shadowColor = color.cgColor
//        self.layer.shadowOpacity = Float(1)
//        self.layer.shadowOffset = CGSize(width: 0, height: 5)
//        layer.shadowRadius = 30

        self.borderColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0)
        self.bottomBorderWidth = 0.5
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringToFront()
    }
}
