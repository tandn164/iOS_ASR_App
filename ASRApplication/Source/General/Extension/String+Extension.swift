//
//  String+Extension.swift
//

import Foundation
import UIKit

extension String {
    
    public var localized: String {
        let currentLocale = AppPreferences.instance.language
        guard
            let bundlePath = Bundle.main.path(forResource: currentLocale, ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
            return self
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        //        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    public var localizedLowercase: String {
        return self.localized.lowercased()
    }
    
    public var localizedUppercase: String {
        return self.localized.uppercased()
    }
    
    public func index(with offset: Int) -> Index {
        return self.index(startIndex, offsetBy: offset)
    }
    
    public func subString(from offset: Int) -> String {
        let fromIndex = index(with: offset)
        return String(self[fromIndex...])
    }
    
    public func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    public func isValidPassword() -> Bool {
        if self.contains(" ") {
            return false
        }
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[-(!#<>&@%+$*._)]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    public var isDigits: Bool {
        if isEmpty { return false }
        // The inverted set of .decimalDigits is every character minus digits
        let nonDigits = CharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: nonDigits) == nil
    }
    
    func formatLocalized(_ args: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: self)
        let result = withVaList(args) {
            (NSString(format: format, locale: NSLocale.current, arguments: $0) as String)
        }
        
        return result
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        return heightWithConstrainedWidth(width: width, attributes: [NSAttributedString.Key.font: font])
    }
    
    func heightWithConstrainedWidth(width: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: attributes,
                                            context: nil)
        return ceil(boundingBox.height)
    }
    
    func widthWithFont(_ font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return boundingBox.width
    }
    
    func isEmtyString() -> Bool {
        if self.isEmpty {
            return true
        }
        if self.trimmingCharacters(in: .whitespaces).isEmpty {
            // string contains non-whitespace characters
            return true
        }
        return false
    }
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func isValidUrl() -> Bool {
        let urlRegEx = "^([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
    func convertDate(currentFormat: String , formatConvert: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = currentFormat
        let showDate = inputFormatter.date(from: self)
        inputFormatter.dateFormat = formatConvert
        let resultDate = inputFormatter.string(from: showDate ?? Date())
        return resultDate
    }
    
    func toDouble(_ locale: Locale = Locale.current) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.usesGroupingSeparator = true
        if let result = formatter.number(from: self)?.doubleValue {
            return result
        } else {
            return nil
        }
    }
    
    /// Assuming the current string is base64 encoded, this property returns a String
    /// initialized by converting the current string into Unicode characters, encoded to
    /// utf8. If the current string is not base64 encoded, nil is returned instead.
    var base64Decoded: String? {
        guard let base64 = Data(base64Encoded: self) else { return nil }
        let utf8 = String(data: base64, encoding: .utf8)
        return utf8
    }
    
    /// Returns a base64 representation of the current string, or nil if the
    /// operation fails.
    var base64Encoded: String? {
        let utf8 = self.data(using: .utf8)
        let base64 = utf8?.base64EncodedString()
        return base64
    }
    
}

extension Bundle {
    var appVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var mainAppVersion: String {
        Bundle.main.appVersion ?? "1.0"
    }
}
