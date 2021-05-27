//
//  AppTextView.swift
//

import UIKit

//@IBDesignable
class AppTextView: UIView {
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
    @IBInspectable var text: String! {
        set {
            self.textView.text = newValue
        }
        get {
            return self.textView.text
        }
    }
    @IBInspectable var font: UIFont? {
        set {
            self.textView.font = newValue
        }
        get {
            return self.textView.font
        }
    }
    
    @IBInspectable var textColor: UIColor? {
        set {
            self.textView.textColor = newValue
        }
        get {
            return self.textView.textColor
        }
    }
    
    @IBInspectable var textAlignment: NSTextAlignment {
        set {
            self.textView.textAlignment = newValue
        }
        get {
            return self.textView.textAlignment
        }
    }
    
    @IBInspectable var isEditable: Bool {
        set {
            self.textView.isEditable = newValue
        }
        get {
            return self.textView.isEditable
        }
    }
    
    @IBInspectable var isSelectable: Bool {
        set {
            self.textView.isSelectable = newValue
        }
        get {
            return self.textView.isSelectable
        }
    }
    
    @IBInspectable var dataDetectorTypes: UIDataDetectorTypes {
        set {
            self.textView.dataDetectorTypes = newValue
        }
        get {
            return self.textView.dataDetectorTypes
        }
    }
    
    @IBInspectable var allowsEditingTextAttributes: Bool {
        set {
            self.textView.allowsEditingTextAttributes = newValue
        }
        get {
            return self.textView.allowsEditingTextAttributes
        }
    }
    
    var attributedText: NSAttributedString! {
        set {
            self.textView.attributedText = newValue
        }
        get {
            return self.textView.attributedText
        }
    }
    
    @IBInspectable var typingAttributes: [String : Any] {
        set {
            self.textView.typingAttributes = convertToNSAttributedStringKeyDictionary(newValue)
        }
        get {
            return convertFromNSAttributedStringKeyDictionary(self.textView.typingAttributes)
        }
    }

    @IBInspectable var maxLength: Int = 0
    
    
    private var horizontalSpacing: CGFloat = 15.0
    private var verticalSpacing: CGFloat = 15.0
    private var leftImageHorizontalPadding: CGFloat = 5.0
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 14)
        view.borderWidth = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leftImageView: UIImageView = {
        let view = UIImageView(image: self.leftImage)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    weak var delegate: AppTextViewDelegate?
    
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
        self.addSubview(self.textView)
        self.textView.delegate = self
        
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
        
        let topTv = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -10)
        let leadingTv = NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: self.leftImageView, attribute: .trailing, multiplier: 1, constant: 10)
        let trailingTv = NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 8)
        let bottomTv = NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: self.underlineView, attribute: .top, multiplier: 1, constant: -10)
        
        let bottomLine = NSLayoutConstraint(item: underlineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let heightLine = NSLayoutConstraint(item: underlineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let leadingLine = NSLayoutConstraint(item: underlineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingLine = NSLayoutConstraint(item: underlineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        let bottomGLine = NSLayoutConstraint(item: gradientUnderlineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let heightGLine = NSLayoutConstraint(item: gradientUnderlineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let leadingGLine = NSLayoutConstraint(item: gradientUnderlineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingGLine = NSLayoutConstraint(item: gradientUnderlineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.addConstraints([topImage, leadingImage, leadingTv, topTv, trailingTv, bottomTv, bottomLine, bottomGLine, heightLine, heightGLine, leadingLine, leadingGLine, trailingGLine, trailingLine])
    }
    
    @objc fileprivate func didFocus() {
        self.underlineView.isHidden = true
        self.gradientUnderlineView.isHidden = false
    }
    
    @objc fileprivate func didLoseFocus() {
        self.underlineView.isHidden = false
        self.gradientUnderlineView.isHidden = true
    }
}

@objc protocol AppTextViewDelegate: class {
    @available(iOS 2.0, *)
    @objc optional func textViewShouldBeginEditing(_ textView: AppTextView) -> Bool
    
    @available(iOS 2.0, *)
    @objc optional func textViewShouldEndEditing(_ textView: AppTextView) -> Bool
    
    @objc @available(iOS 2.0, *)
    optional func textViewDidBeginEditing(_ textView: AppTextView)
    
    @objc @available(iOS 2.0, *)
    optional func textViewDidEndEditing(_ textView: AppTextView)
}

extension AppTextView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.didFocus()
        return self.delegate?.textViewShouldBeginEditing?(self) ?? true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.didLoseFocus()
        self.delegate?.textViewDidEndEditing?(self)
    }

    func textField(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textView.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        return maxLength <= 0 || updatedText.count <= maxLength
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = (textView.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        return maxLength <= 0 || updatedText.count <= maxLength
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
