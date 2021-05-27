//Screen.swift

import UIKit

struct Screen {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    static var safeAreaHeight: CGFloat {
        return Screen.height - Screen.safeAreaBottom - Screen.safeAreaTop
    }
    
    static var safeAreaTop: CGFloat {
         if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindow {
                return window.safeAreaInsets.top
            }
         }
         return 0
    }
    
    static var safeAreaBottom: CGFloat {
        if #available(iOS 11, *) {
           if let window = UIApplication.shared.keyWindow {
               return window.safeAreaInsets.bottom
           }
        }
        return 0
    }
}
