//
//  AppSearchBar.swift
//

import UIKit
import RxSwift
import RxCocoa

//@IBDesignable
class AppSearchBar: UIView {
    weak var delegate: AppSearchBarDelegate?
    private var isSubviewLayouted: Bool = false
    fileprivate let spacing: CGFloat = 10
    
    fileprivate lazy var iconSearchView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        
        return imageView
    }()
    
    fileprivate lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.delegate = self
        textField.backgroundColor = UIColor.clear
        textField.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        textField.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750), for: .horizontal)
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.clearButtonMode = .whileEditing
        
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)

        textField.maxLength = 128
        
        return textField
    }()
    
    fileprivate var leadingContainerViewConstraint: NSLayoutConstraint!
    fileprivate var widthContainerViewConstraint: NSLayoutConstraint!
    fileprivate var originLeadingContainerViewConstraintConstant: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isSubviewLayouted {
            originLeadingContainerViewConstraintConstant = (self.frame.width - self.iconSearchView.frame.width - self.textField.frame.width) / 2
            widthContainerViewConstraint.constant = frame.width - 2 * spacing
            isSubviewLayouted = true
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    
    func forceUpdateConstraintConstant() {
        originLeadingContainerViewConstraintConstant = (self.frame.width - self.iconSearchView.frame.width - self.textField.frame.width) / 2
    }
}

private extension AppSearchBar {
    func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(self.iconSearchView)
        containerView.addSubview(self.textField)
        containerView.backgroundColor = UIColor.clear
        
        self.addSubview(containerView)
        
        let centerXC = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYC = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        leadingContainerViewConstraint = NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: spacing)
        leadingContainerViewConstraint.priority = UILayoutPriority(rawValue: 500)
        
        widthContainerViewConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.width - 2 * spacing)
        
        self.addConstraints([centerXC, centerYC, widthContainerViewConstraint, leadingContainerViewConstraint])
        leadingContainerViewConstraint.isActive = false
        
        let topI = NSLayoutConstraint(item: iconSearchView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
        let leadingI = NSLayoutConstraint(item: iconSearchView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingI = NSLayoutConstraint(item: iconSearchView, attribute: .right, relatedBy: .equal, toItem: textField, attribute: .left, multiplier: 1, constant: -spacing)
        let bottomI = NSLayoutConstraint(item: iconSearchView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        
        let topT = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
        let trailingT = NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomT = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        
        containerView.addConstraints([topI, leadingI, trailingI, bottomI, topT, trailingT, bottomT])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func textChanged(_ sender: UITextField) {
        self.delegate?.textFieldChangeEditing?(self, with: sender.text)
    }
    
    @objc func onTap(_ gesture: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }
}

extension AppSearchBar {
    @IBInspectable var iconSearch: UIImage? {
        set {
            self.iconSearchView.image = newValue
        }
        get {
            return self.iconSearchView.image
        }
    }
    
    @IBInspectable var text: String? {
        set {
            self.textField.text = newValue
        }
        get {
            return self.textField.text
        }
    }
    
    @IBInspectable var placeholder: String? {
        set {
            self.textField.placeholder = newValue
        }
        get {
            return self.textField.placeholder
        }
    }
    
    var attributedText: NSAttributedString? {
        set {
            self.textField.attributedText = newValue
        }
        get {
            return self.textField.attributedText
        }
    }
    
    var attributedPlaceholder: NSAttributedString? {
        set {
            self.textField.attributedPlaceholder = newValue
        }
        get {
            return self.textField.attributedPlaceholder
        }
    }
    
    var textColor: UIColor? {
        set {
            self.textField.textColor = newValue
        }
        get {
            return self.textField.textColor
        }
    }
    
    var font: UIFont? {
        set {
            self.textField.font = newValue
        }
        get {
            return self.textField.font
        }
    }
    
    var textAlignment: NSTextAlignment {
        set {
            self.textField.textAlignment = newValue
        }
        get {
            return self.textField.textAlignment
        }
    }
    
    var clearsOnBeginEditing: Bool {
        set {
            self.textField.clearsOnBeginEditing = newValue
        }
        get {
            return self.textField.clearsOnBeginEditing
        }
    }
    
    var isEditing: Bool {
        get {
            return self.textField.isEditing
        }
    }
    
    var allowsEditingTextAttributes: Bool {
        set {
            self.textField.allowsEditingTextAttributes = newValue
        }
        get {
            return self.textField.allowsEditingTextAttributes
        }
    }
    
    var clearButtonMode: UITextField.ViewMode {
        set {
            self.textField.clearButtonMode = newValue
        }
        get {
            return self.textField.clearButtonMode
        }
    }
}

extension AppSearchBar: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.leadingContainerViewConstraint.constant = self.originLeadingContainerViewConstraintConstant
        self.leadingContainerViewConstraint.isActive = true
        UIView.animate(withDuration: Constant.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.leadingContainerViewConstraint.constant = 10
            self.layoutIfNeeded()
        })
        
        return self.delegate?.textFieldShouldBeginEditing?(self) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidBeginEditing?(self)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" || textField.text == nil {
            UIView.animate(withDuration: Constant.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
                self.leadingContainerViewConstraint.constant = self.originLeadingContainerViewConstraintConstant
                self.layoutIfNeeded()
            }){
                _ in
                self.leadingContainerViewConstraint.isActive = false
            }
        }
        
        return self.delegate?.textFieldShouldEndEditing?(self) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing?(self)
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.delegate?.textFieldDidEndEditing?(self, reason: reason)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.delegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.delegate?.textFieldShouldClear?(self) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.delegate?.textFieldShouldReturn?(self) ?? false
    }
    
}

@objc protocol AppSearchBarDelegate: NSObjectProtocol {
    @objc optional func textFieldChangeEditing(_ searchBar: AppSearchBar, with text: String?)
    
    @objc optional func textFieldShouldBeginEditing(_ seachBar: AppSearchBar) -> Bool
    
    @objc optional func textFieldDidBeginEditing(_ seachBar: AppSearchBar)
    
    @objc optional func textFieldShouldEndEditing(_ seachBar: AppSearchBar) -> Bool
    
    @objc optional func textFieldDidEndEditing(_ seachBar: AppSearchBar)
    
    @available(iOS 10.0, *)
    @objc optional func textFieldDidEndEditing(_ seachBar: AppSearchBar, reason: UITextField.DidEndEditingReason)
    
    @objc optional func textField(_ seachBar: AppSearchBar, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    
    @objc optional func textFieldShouldClear(_ seachBar: AppSearchBar) -> Bool
    
    @objc optional func textFieldShouldReturn(_ seachBar: AppSearchBar) -> Bool
}

extension Reactive where Base: AppSearchBar {
    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
}
