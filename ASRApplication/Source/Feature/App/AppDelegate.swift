//
//  AppDelegate.swift
//

import UIKit
import Reachability
import IQKeyboardManagerSwift

import UserNotifications

var pendingShowChatWithUserId: Int?
var pendingShowLevelUpWithLevel: Int?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var reachability: Reachability!
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppConfig.initialize()
        StorageManager.initialize()
        CacheFactory.initialize()
        IQKeyboardManager.shared.enable = true
        let vc = TabbarViewController()
        vc.selectedIndex = 0
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } else {
            UIApplication.shared.keyWindow?.set(rootViewController: vc)
        }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handleReceivedNotification(application, userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("DEVICE TOKEN = \(token)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Application receive remote notification")
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let vc = TabbarViewController()
        vc.selectedIndex = 0
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } else {
            UIApplication.shared.keyWindow?.set(rootViewController: vc)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Notifier.globalNotifier.notifyObservers(.gApplicationDidEnterBackground)
        reachability.stopNotifier()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        Notifier.globalNotifier.notifyObservers(.gApplicationWillEnterForeground)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        application.applicationIconBadgeNumber = 0
        
        Notifier.globalNotifier.notifyObservers(.gApplicationDidBecomeActive)
        
        reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            Notifier.globalNotifier.notifyObservers(.gReachable)
        }
        reachability.whenUnreachable = { reachability in
            Notifier.globalNotifier.notifyObservers(.gUnreachable)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Handle notification
    private func handleReceivedNotification(_ application: UIApplication, userInfo: [AnyHashable : Any]) {
        if let event = userInfo["event"] as? String {
            switch event {
            case "message":
                let id = userInfo["id"] as? Int
                handleNewMessageNotification(application, id: id)
                break
            case "new_post":
                let id = userInfo["id"] as? Int
                handleNewPostNotification(id: id)
                break
            default:
                break
            }
        }
    }
    
    private func handleNewMessageNotification(_ application: UIApplication, id: Int?) {
        if application.applicationState == UIApplication.State.active {
            //Do nothing in this state
            return
        }
    }
    private func handleNewPostNotification(id: Int?) {
    }
    
    
    struct AppUtility {
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                //                    delegate.orientationLock = orientation
            }
        }
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            //                self.lockOrientation(orientation)
            //                UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
}
