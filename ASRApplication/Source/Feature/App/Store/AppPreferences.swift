//
//  AppPreferences.swift
//

import Foundation

class AppPreferences {
    private let kFacebookConnected = "connect_facebook"
    private let kTwitterConnected = "connect_twitter"
    private let kGoogleConnected = "connect_google"
    private let kShareFacebook = "share_facebook"
    private let kShareTwitter = "share_twitter"
    private let kShareGoogle = "share_google"
    private let kConnectedAccounts = "kConnectedAccounts"
    private let kReceiveNotifications = "kReceiveNotifications"
    private let kShowFansPublicly = "kShowFansPublicly"
    private let kTopFanRequirement = "kTopFanRequirement"
    private let kUseFrontCamera = "kUseFrontCamera"
    private let kSharePremiumOnly = "kSharePremiumOnly"
    private let kSuggestSubcribeCount = "kSuggestSubcribeCount"
    private let kFirstRun = "kFirstRun"
    private let kLatestVersion = "kLatestVersion"
    private let kExperienceLevel = "kExperienceLevel"
    private let kCurrentLocale = "kCurrentLocale"

    static let _instance = AppPreferences()

    static var instance: AppPreferences {
        get {
            return _instance
        }
    }

    private init() {
        UserDefaults.standard.register(defaults: [
            kShareFacebook: true,
            kShareTwitter: true,
            kShareGoogle: true,
            kReceiveNotifications: true,
            kShowFansPublicly: true,
            kTopFanRequirement: 10000,
            kSuggestSubcribeCount: 3,
            kFirstRun: true,
            kExperienceLevel: 0,
            kCurrentLocale: Constant.Language.EN.rawValue
        ])
    }

    var isFacebookConnected: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kFacebookConnected)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kFacebookConnected)
        }
    }
    var isTwitterConnected: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kTwitterConnected)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kTwitterConnected)
        }
    }
    var isGoogleConnected: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kGoogleConnected)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kGoogleConnected)
        }
    }

    var isShareFacebook: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kShareFacebook)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kShareFacebook)
        }
    }

    var isShareTwitter: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kShareTwitter)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kShareTwitter)
        }
    }

    var isShareGoogle: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kShareGoogle)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kShareGoogle)
        }
    }

    var receiveNotifications: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kReceiveNotifications)
        }
        get {
            return UserDefaults.standard.bool(forKey: kReceiveNotifications)
        }
    }

    var showFansPublicly: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kShowFansPublicly)
        }
        get {
            return UserDefaults.standard.bool(forKey: kShowFansPublicly)
        }
    }

    var topFanRequirement: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: kTopFanRequirement)
        }
        get {
            return UserDefaults.standard.integer(forKey: kTopFanRequirement)
        }
    }

    var useFrontCamera: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kUseFrontCamera)
        }
        get {
            return UserDefaults.standard.bool(forKey: kUseFrontCamera)
        }
    }

    var isSharePremiumOnly: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kSharePremiumOnly)
        }
        get {
            return UserDefaults.standard.bool(forKey: kSharePremiumOnly)
        }
    }

    var suggestSubscribeCount: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: kSuggestSubcribeCount)
        }
        get {
            return UserDefaults.standard.integer(forKey: kSuggestSubcribeCount)
        }
    }

    var isFirstRun: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kFirstRun)
        }
        get {
            return UserDefaults.standard.bool(forKey: kFirstRun)
        }
    }

    var lastestVersion: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: kLatestVersion)
        }
        get {
            return UserDefaults.standard.integer(forKey: kLatestVersion)
        }
    }
    
    var experienceLevel: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: kExperienceLevel)
        }
        get {
            return UserDefaults.standard.integer(forKey: kExperienceLevel)
        }
    }
    
    var language: Constant.Language.RawValue {
        set {
            UserDefaults.standard.set(newValue, forKey: kCurrentLocale)
        }
        get {
            return UserDefaults.standard.string(forKey: kCurrentLocale)!
        }
    }
}
