//TabbarViewController.swift

import UIKit
import SnapKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let globalDataController = ControllerFactory.globalDataController
    var sttJapanController: STTJapanViewController!
    
    static var current: TabbarViewController?
    var notiCount: Int = 0 {
        didSet {
            if notiCount == 0 {
                tabBar.removeItemBadge(atIndex: 0)
            } else {
                tabBar.addItemBadge(atIndex: 0, value: notiCount)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TabbarViewController.current = self
        self.delegate = self
        sttJapanController = STTJapanViewController()
        let navSttJapan = UINavigationController(rootViewController: sttJapanController)
        self.viewControllers = [navSttJapan]
        navSttJapan.tabBarItem = UITabBarItem(title: "STT",
                                              image: nil,
                                              selectedImage: nil)
        self.setupTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: Setup Tabbar
    func setupTabbar() {
        self.tabBar.barTintColor = AppResources.Color.fm_black
        self.tabBar.isTranslucent = false
        self.tabBar.invalidateIntrinsicContentSize()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppResources.Color.fm_white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppResources.Color.fm_orange], for: .selected)
    }
    
    //MARK: Navigate UI
    @objc func navigateToLive(){
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        print(tabBarIndex)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
