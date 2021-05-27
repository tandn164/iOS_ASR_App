//
//  UITag.swift
//

import Foundation
import UIKit

class UITag: UIButton {
    let padding: CGFloat = 9
    var normalColor = UIColor.white.withAlphaComponent(0.15)
    var selectedColor = UIColor.white.withAlphaComponent(0.15)

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }

    func initSubviews() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        self.setTitleColor(UIColor.white, for: .normal)
    }

    var active = false {
        didSet {
            self.backgroundColor = active ? selectedColor : normalColor
        }
    }
    
    func toggleSelected() {
        //active = !active
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius = self.frame.size.height / 2
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
}
