//
//  AppTextField.swift
//

import UIKit

//@IBDesignable
class AppTextField: UIView {
    @IBInspectable var startColor: UIColor = UIColor(red: 255 / 255.0, green: 33 / 255.0, blue: 83 / 255.0, alpha: 1)
    @IBInspectable var endColor: UIColor = UIColor(red: 252 / 255.0, green: 94 / 255.0, blue: 34 / 255.0, alpha: 1)
    @IBInspectable var defaultColor: UIColor = UIColor(red: 233 / 255.0, green: 239 / 255.0, blue: 241 / 255.0, alpha: 1) {
        didSet {
            updateLayer()
        }
    }
    @IBInspectable var leftImage: UIImage? {
        didSet {
            self.leftImageView.image = leftImage
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
    
    var attributedText: NSAttributedString?{
        set {
            self.textField.attributedText = newValue
        }
        get {
            return self.textField.attributedText
        }
    }
    
    @IBInspectable var textColor: UIColor? {
        set {
            self.textField.textColor = newValue
        }
        get {
            return self.textField.textColor
        }
    }
    
    @IBInspectable var font: UIFont? {
        set {
            self.textField.font = newValue
        }
        get {
            return self.textField.font
        }
    }
    
    @IBInspectable var textAlignment: NSTextAlignment {
        set {
            self.textField.textAlignment = newValue
        }
        get {
            return self.textField.textAlignment
        }
    }
    
    @IBInspectable var defaultTextAttributes: [String : Any] {
        set {
            self.textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(newValue)
        }
        get {
            return convertFromNSAttributedStringKeyDictionary(self.textField.defaultTextAttributes)
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
    
    var attributedPlaceholder: NSAttributedString? {
        set {
            self.textField.attributedPlaceholder = newValue
        }
        get {
            return self.textField.attributedPlaceholder
        }
    }
    
    @IBInspectable var clearsOnBeginEditing: Bool {
        set {
            self.textField.clearsOnBeginEditing = newValue
        }
        get {
            return self.textField.clearsOnBeginEditing
        }
    }
    
    @IBInspectable var adjustsFontSizeToFitWidth: Bool {
        set {
            self.textField.adjustsFontSizeToFitWidth = newValue
        }
        get {
            return self.textField.adjustsFontSizeToFitWidth
        }
    }
    
    @IBInspectable var minimumFontSize: CGFloat {
        set {
            self.textField.minimumFontSize = newValue
        }
        get {
            return self.textField.minimumFontSize
        }
    }
    
    @IBInspectable var background: UIImage? {
        set {
            self.textField.background = newValue
        }
        get {
            return self.textField.background
        }
    }
    
    @IBInspectable var disabledBackground: UIImage? {
        set {
            self.textField.disabledBackground = newValue
        }
        get {
            return self.textField.disabledBackground
        }
    }
    
    
    var isEditing: Bool {
        get {
            return self.textField.isEditing
        }
    }
    
    @IBInspectable var allowsEditingTextAttributes: Bool {
        set {
            self.textField.allowsEditingTextAttributes = newValue
        }
        get {
            return self.textField.allowsEditingTextAttributes
        }
    }
    
    @IBInspectable var typingAttributes: [String : Any]? {
        set {
            self.textField.typingAttributes = convertToOptionalNSAttributedStringKeyDictionary(newValue)
        }
        get {
            return convertFromOptionalNSAttributedStringKeyDictionary(self.textField.typingAttributes)
        }
    }
    
    @IBInspectable var clearButtonMode: UITextField.ViewMode {
        set {
            self.textField.clearButtonMode = newValue
        }
        get {
            return self.textField.clearButtonMode
        }
    }

    @IBInspectable var maxLength: Int {
        set {
            self.textField.maxLength = newValue
        }
        get {
            return self.textField.maxLength
        }
    }
    
    private var horizontalSpacing: CGFloat = 15.0
    private var verticalSpacing: CGFloat = 15.0
    private var leftImageHorizontalPadding: CGFloat = 5.0
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.font = UIFont.systemFont(ofSize: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .none
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        return view
    }()
    
    private lazy var leftImageView: UIImageView = {
        let view = UIImageView(image: self.leftImage)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        
        return view
    }()
    
    weak var delegate: AppTextFieldDelegate?
    
    private let startPoint = CGPoint(x: 0.0, y: 0.5)
    private let endPoint = CGPoint(x: 1.0, y: 0.5)
    
    private var underlineView: UIView!
    private var gradientUnderlineView: UIGradientView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        self.addSubview(self.leftImageView)
        self.addSubview(self.textField)
        self.textField.delegate = self
        setupLayer()
        setConstraints()
        self.clipsToBounds = true
    }
    
    private func setupLayer() {
        underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = self.defaultColor
        self.addSubview(underlineView)
        
        gradientUnderlineView = UIGradientView()
        gradientUnderlineView.startColor = startColor
        gradientUnderlineView.endColor = endColor
        gradientUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(gradientUnderlineView)
        
        gradientUnderlineView.isHidden = true
    }
    
    private func updateLayer() {
        self.bringSubviewToFront(gradientUnderlineView)
    }
    
    private func setConstraints() {
        let topImage = NSLayoutConstraint(item: leftImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let leadingImage = NSLayoutConstraint(item: leftImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        let topTv = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let leadingTv = NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self.leftImageView, attribute: .trailing, multiplier: 1, constant: 15)
        let trailingTv = NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        let bottomLine = NSLayoutConstraint(item: underlineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let heightLine = NSLayoutConstraint(item: underlineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let leadingLine = NSLayoutConstraint(item: underlineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingLine = NSLayoutConstraint(item: underlineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        let bottomGLine = NSLayoutConstraint(item: gradientUnderlineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let heightGLine = NSLayoutConstraint(item: gradientUnderlineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let leadingGLine = NSLayoutConstraint(item: gradientUnderlineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingGLine = NSLayoutConstraint(item: gradientUnderlineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.addConstraints([topImage, leadingImage, leadingTv, topTv, trailingTv, bottomLine, bottomGLine, heightLine, heightGLine, leadingLine, leadingGLine, trailingGLine, trailingLine])
    }
    
    @objc fileprivate func didFocus() {
        self.underlineView.isHidden = true
        self.gradientUnderlineView.isHidden = false
    }
    
    @objc fileprivate func didLoseFocus() {
        self.underlineView.isHidden = false
        self.gradientUnderlineView.isHidden = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.leftImageHorizontalPadding + self.leftImageView.bounds.width + self.textField.bounds.width + self.horizontalSpacing, height: self.leftImageView.bounds.width + self.verticalSpacing + self.underlineView.bounds.height)
    }
}

@objc protocol AppTextFieldDelegate: class {
    @objc @available(iOS 2.0, *)
    optional func textFieldShouldBeginEditing(_ textField: AppTextField) -> Bool // return NO to disallow editing.
    
    @objc @available(iOS 2.0, *)
    optional func textFieldDidBeginEditing(_ textField: AppTextField) // became first responder
    
    @objc @available(iOS 2.0, *)
    optional func textFieldShouldEndEditing(_ textField: AppTextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    
    @objc @available(iOS 2.0, *)
    optional func textFieldDidEndEditing(_ textField: AppTextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
}

extension AppTextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.didFocus()
        return self.delegate?.textFieldShouldBeginEditing?(self) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.didLoseFocus()
        self.delegate?.textFieldDidEndEditing?(self)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKeyDictionary(_ input: [NSAttributedString.Key: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromOptionalNSAttributedStringKeyDictionary(_ input: [NSAttributedString.Key: Any]?) -> [String: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
