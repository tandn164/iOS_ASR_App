//
//  UIAvatar.swift
//

import Foundation
import UIKit

class UIAvatar: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius = self.frame.size.width / 2
    }
}
