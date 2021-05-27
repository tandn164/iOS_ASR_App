//
//  LocalizationHelper.swift
//

import Foundation

class LocalizationHelper {
    
    private var enBundle: Bundle?
    private var jaBundle: Bundle?
    
    init() {
        let enBundlePath = Bundle.main.path(forResource: Constant.Language.EN.rawValue, ofType: "lproj")
        enBundle = Bundle(path: enBundlePath!)
        let jaBundlePath = Bundle.main.path(forResource: Constant.Language.JA.rawValue, ofType: "lproj")
        jaBundle = Bundle(path: jaBundlePath!)
    }
    
    static let instance = LocalizationHelper()
    
    func localized(_ key: String?) -> String? {
        guard let key = key else {
            return nil
        }
        var bundle: Bundle?
        switch AppPreferences.instance.language {
        case Constant.Language.EN.rawValue:
            bundle = enBundle
        default:
            bundle = jaBundle
        }
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: key, comment: key)
    }
    
    func en(_ key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: enBundle!, value: key, comment: key)
    }
    
    func ja(_ key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: enBundle!, value: key, comment: key)
    }
    
    func localized(_ key: String, _ locale: String) -> String {
        var bundle: Bundle?
        switch locale {
        case Constant.Language.EN.rawValue:
            bundle = enBundle
        default:
            bundle = jaBundle
        }
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: key, comment: key)
    }
    
}
