//AppScreen.swift

import Foundation
import UIKit

class AppScreen: XibView {
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var bottomToolbar: UIView!
    @IBOutlet weak var topToolbarConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToolbarConstraint: NSLayoutConstraint!

    private var _topToolbarHeight: CGFloat = 0
    private var _bottomToolbarHeight: CGFloat = 0
    @IBInspectable var topToolbarHeight: CGFloat {
        get {
            return _topToolbarHeight > 0 ? _topToolbarHeight : (topToolbar?.frame.height ?? 0)
        }
        set {
            _topToolbarHeight = newValue
        }
    }
    @IBInspectable var bottomToolbarHeight: CGFloat {
        get {
            return _bottomToolbarHeight > 0 ? _bottomToolbarHeight : (bottomToolbar?.frame.height ?? 0)
        }
        set {
            _bottomToolbarHeight = newValue
        }
    }

    var isToolbarHidden = false
    var shouldUpdateToolbarOffset = true
    var hasTopToolbar = false
    var hasBottomToolbar = false
    let contentHeightThreshold: CGFloat = 70

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topToolbar?.bringToFront()
        bottomToolbar?.bringToFront()
    }
}

extension AppScreen {
    open override func viewDidAppear(_ data: Any? = nil) {
        super.viewDidAppear(data)

        hasTopToolbar = topToolbarHeight > 0 && topToolbarConstraint != nil
        hasBottomToolbar = bottomToolbarHeight > 0 && bottomToolbarConstraint != nil
        if contentView == nil {
            contentView = self
        }
    }

    override func viewDidReappear(_ data: Any?) {
        super.viewDidReappear(data)
        if contentView == nil {
            contentView = self
        }
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        if contentView != nil && contentView == self {
            contentView = nil
        }
    }
}

extension AppScreen {
    override func update(_ command: Command, data: Any?) {
        switch command {
        case .vStartUpdateToolbarsOffset:
            startUpdateToobarOffset(data as! [String: Any])
        case .vUpdateToolbarsOffset:
            updateToolbarOffset(data as! [String: Any])
        case .vUpdateToolbarsVisibility:
            updateToolbarVisibility(data as! [String: Any])
        case .vEnableUpdateToolbarsOffset:
            shouldUpdateToolbarOffset = true
        case .vDisableUpdateToolbarsOffset:
            shouldUpdateToolbarOffset = false
        case .vShowToolbars:
            showToolbars()
        default:
            super.update(command, data: data)
        }
    }

    func startUpdateToobarOffset(_ data: [String: Any]) {
        if hasTopToolbar {
            if !isToolbarHidden {
                let scrollView = data[Constant.ViewParam.scrollView] as! UIScrollView
                if scrollView.contentSize.height - contentHeightThreshold < scrollView.frame.height + topToolbarHeight + bottomToolbarHeight {
                    // content always visible => don't hide toolbars
                    if let tableView = scrollView as? AppTableView {
                        tableView.lastContentOffset = nil
                    } else if let collectionView = scrollView as? AppCollectionView {
                        collectionView.lastContentOffset = nil
                    }
                }
            }
        }
    }

    func shouldUpdateOffset(_ data: [String: Any]) -> Bool {
        let scrollView = data[Constant.ViewParam.scrollView] as! UIScrollView
        if let tableView = scrollView as? AppTableView {
            return tableView.lastContentOffset != nil
        } else if let collectionView = scrollView as? AppCollectionView {
            return collectionView.lastContentOffset != nil
        }
        return false
    }

    func updateToolbarOffset(_ data: [String: Any]) {
        if !shouldUpdateToolbarOffset {
            return
        }
        let offset = data[Constant.ViewParam.offset] as! CGFloat

        if !shouldUpdateOffset(data) {
            return
        }

        if hasTopToolbar {
            if isToolbarHidden {
                if offset >= 0 {
                    let topOffset = min(topToolbarHeight, offset)
                    topToolbarConstraint.constant = -topToolbarHeight + topOffset
                }
            } else {
                if offset <= 0 {
                    let topOffset = max(-topToolbarHeight, offset)
                    topToolbarConstraint.constant = topOffset
                }
            }
        }

        if hasBottomToolbar {
            if isToolbarHidden {
                if offset >= 0 {
                    let bottomOffset = min(bottomToolbarHeight, offset)
                    bottomToolbarConstraint.constant = -bottomToolbarHeight + bottomOffset
                }
            } else {
                if offset <= 0 {
                    let bottomOffset = max(-bottomToolbarHeight, offset)
                    bottomToolbarConstraint.constant = bottomOffset
                }
            }
        }


    }

    func updateToolbarVisibility(_ data: [String: Any]) {
        if !hasTopToolbar && !hasBottomToolbar {
            return
        }
        let offset = data[Constant.ViewParam.offset] as! CGFloat

        let toolbarHeight = max(topToolbarHeight, bottomToolbarHeight)

        if self.isToolbarHidden {
            //            if offset >= 0 {
            if offset > toolbarHeight / 2 {
                self.showToolbars()
            } else {
                self.hideToolbars()
            }
            //            }
        } else {
            //            if offset <= 0 {
            if -offset <= toolbarHeight / 2 {
                self.showToolbars()
            } else {
                self.hideToolbars()
            }
            //            }
        }
    }

    func hideToolbars() {
        if hasTopToolbar {
            let toolbarHeight = topToolbarHeight
            if self.topToolbarConstraint.constant != -toolbarHeight {
                UIView.animate(withDuration: Constant.animationDuration, animations: {
                    self.topToolbarConstraint.constant = -toolbarHeight
                    self.contentView.layoutIfNeeded()
                })
            }
        }

        if hasBottomToolbar {
            let toolbarHeight = bottomToolbarHeight
            if self.bottomToolbarConstraint.constant != -toolbarHeight {
                UIView.animate(withDuration: 0.5, animations: {
                    self.bottomToolbarConstraint.constant = -toolbarHeight
                    self.contentView.layoutIfNeeded()
                })
            }
        }
        self.isToolbarHidden = true
    }

    func showToolbars() {
        if hasTopToolbar {
            if self.topToolbarConstraint.constant != 0 { // if toolbar is correct position, do nothing
                UIView.animate(withDuration: Constant.animationDuration, animations: {
                    self.topToolbarConstraint.constant = 0
                    self.contentView.layoutIfNeeded()
                })
            }
        }
        if hasBottomToolbar {
            if self.bottomToolbarConstraint.constant != 0 { // if toolbar is correct position, do nothing
                UIView.animate(withDuration: 0.5, animations: {
                    self.bottomToolbarConstraint.constant = 0
                    self.contentView.layoutIfNeeded()
                })
            }
        }
        self.isToolbarHidden = false
    }
}
