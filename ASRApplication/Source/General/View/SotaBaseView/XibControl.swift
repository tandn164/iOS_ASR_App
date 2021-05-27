//
//  XibControl.swift
//

import Foundation

class XibControl: AppControl {
    @IBOutlet var contentView: UIView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        let name = String(describing: type(of: self))
        if name != String(describing: AppScreen.self) {
            let nib = UINib(nibName: name, bundle: nil)
            nib.instantiate(withOwner: self, options: nil)
            contentView.frame = bounds
            addSubview(contentView)
            contentView.forceConstraintToSuperView()
        }
    }
}
