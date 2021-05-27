//
//  UITabBar+Extension.swift
//

import UIKit

fileprivate let tabBarItemTag: Int = 1000
extension UITabBar {
    public func addItemBadge(atIndex index: Int, value: Int) {
        guard let itemCount = self.items?.count, itemCount > 0 else {
            return
        }
        guard index < itemCount else {
            return
        }
        removeItemBadge(atIndex: index)

        let badgeView = UIView()
        badgeView.tag = tabBarItemTag + Int(index)
        badgeView.layer.cornerRadius = 7.5
        badgeView.backgroundColor = UIColor(hex: 0xF39800)
        
        let label = UILabel()
        label.font = UIFont(name: "Fira Sans", size: 10)
        label.textColor = .white
        label.text = value < 100 ? "\(value)" : "99+"
        badgeView.addSubview(label)
        label.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let tabFrame = self.frame
        let percentX = (CGFloat(index) + 0.5) / CGFloat(itemCount)
        let x = (percentX * tabFrame.size.width).rounded(.up)
        let y = (CGFloat(0.1) * tabFrame.size.height).rounded(.up)
        badgeView.frame = CGRect(x: x, y: 6, width: 15, height: 15)
        addSubview(badgeView)
    }

    //return true if removed success.
    @discardableResult
    public func removeItemBadge(atIndex index: Int) -> Bool {
        for subView in self.subviews {
            if subView.tag == (tabBarItemTag + index) {
                subView.removeFromSuperview()
                return true
            }
        }
        return false
    }
}
