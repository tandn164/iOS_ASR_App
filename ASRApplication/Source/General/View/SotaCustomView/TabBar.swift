//TabBar.swift

import Foundation
import UIKit

class TabBar: UIView {
    var separatorSize = CGSize(width: 1, height: 17)
    var separatorColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
    @IBInspectable var tabData: String = "" {
        didSet {
            tabTitles = tabData.components(separatedBy: ",")
        }
    }
    var tabTitles: [String] = [] {
        didSet {
            tabCounts = []
            for _ in 0..<tabTitles.count {
                tabCounts.append("")
            }
            updateTabCells()
        }
    }
    var tabCounts: [String] = []
    private var _activeIndex = 0
    var activeIndex: Int {
        get {
            return _activeIndex
        }
        set {
            _activeIndex = newValue
            selectActiveTab()
        }
    }
    var tabCells: [TabCell] = []
    weak var delegate: TabBarDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTabCells()
    }
    
    func updateTabCells() {
        self.subviews.forEach({
            $0.removeFromSuperview()
        })
        tabCells = []
        
        let height = self.frame.height
        let width = (self.frame.width - CGFloat(tabTitles.count - 1) * separatorSize.width) / CGFloat(tabTitles.count)
        let separatorY = (self.frame.height - separatorSize.height) / 2
        
        for (index, value) in tabTitles.enumerated() {
            let frame = CGRect(x: CGFloat(index) * (width + separatorSize.width), y: 0, width: width, height: height)
            let tabCell = TabCell(frame: frame)
            tabCell.label.text = value
            tabCell.count = tabCounts[index]
            if index == activeIndex {
                tabCell.active = true
            }

            tabCell.gestureRecognizers?.forEach({tabCell.removeGestureRecognizer($0)})
            let gesture = UITapGestureRecognizer(target: self, action: #selector(TabBar.onTabSelected))
            tabCell.addGestureRecognizer(gesture)
            
            self.addSubview(tabCell)
            tabCells.append(tabCell)
            
            if index < tabTitles.count - 1 {
                let separator = UIView(frame: CGRect(x: frame.minX + frame.width, y: separatorY, width: separatorSize.width, height: separatorSize.height))
                separator.backgroundColor = separatorColor
                self.addSubview(separator)
            }
        }
    }

    func selectActiveTab() {
        for (index, tabCell) in tabCells.enumerated() {
            tabCell.active = index == activeIndex
        }
    }
    
    @objc func onTabSelected(sender: UITapGestureRecognizer) {
        if let tabCell = sender.view as? TabCell {
            if tabCell.active {
                return
            }
            self.subviews.forEach({
                if let tabCell = $0 as? TabCell {
                    tabCell.active = false
                }
            })
            tabCell.active = true
            if let index = self.subviews.filter({$0 is TabCell}).firstIndex(of: tabCell) {
                activeIndex = index
                delegate?.tabBar(self, didSelectTabAt: index)
            }
        }
    }

    func setCount(_ value: String, at index: Int) {
        tabCounts[index] = value
        tabCells[index].count = value
    }
}

protocol TabBarDelegate: class {
    func tabBar(_ tabBar: TabBar, didSelectTabAt index: Int)
}
