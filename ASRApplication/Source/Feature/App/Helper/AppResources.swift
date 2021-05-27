//
//  AppResources.swift
//

import Foundation

class AppResources : NSObject {
    
    private static var m_bundle: Bundle?
    static var bundle: Bundle {
        get {
            if nil == m_bundle {
                let bundlePath = Bundle.main.path(forResource: "Resources", ofType: "bundle")
                m_bundle = Bundle.init(path: bundlePath!)
            }
            return m_bundle!
        }
    }
    
    static let shared = AppResources()
    
    class Color {
        static let fm_clear = UIColor.clear
        static let fm_white = UIColor.white
        static let fm_blue = UIColor(hex: 0x1378E0)
        static let fm_orange = UIColor(hex: 0xF39800)
        static let fm_yellow = UIColor(hex: 0xFFE600)
        static let fm_black = UIColor(hex: 0x070707)
        static let fm_drak_gray = UIColor(hex: 0x858585)
        static let fm_medium_gray = UIColor(hex: 0xA0A0A0)
        static let fm_nero = UIColor(hex: 0x1A1A1A)
        static let fm_unreadNotification = UIColor(hex: 0xFFFBF3)
        static let fm_unfocusTextField = UIColor(hex: 0x000000).withAlphaComponent(0.3)
        static let fm_emptyDataText = UIColor(hex: 0xA6A6A6)
        static let fm_red = UIColor(hex: 0xFF2222)
    }
}
