//UITableViewCell+Extension.swift

import UIKit

extension UITableViewCell {
    class func nib() -> UINib {
        return UINib.init(nibName: String(describing: self), bundle: nil)
    }
    
    class func nibName()-> String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    class func nib() -> UINib {
        return UINib.init(nibName: String(describing: self), bundle: nil)
    }
    
    class func nibName()-> String {
        return String(describing: self)
    }
}

extension UICollectionReusableView {
    class func nib() -> UINib {
        return UINib.init(nibName: String(describing: self), bundle: nil)
    }
    
    class func nibName()-> String {
        return String(describing: self)
    }
}
