//MainNavigationViewController.swift

import Foundation

class MainNavigationViewController: SlideNavigationController {

    var statusBarStyle: UIStatusBarStyle = .lightContent

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let slideNavigationController = SlideNavigationController.sharedInstance()!
        slideNavigationController.leftMenu?.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let slideNavigationController = SlideNavigationController.sharedInstance()!
        slideNavigationController.leftMenu?.viewWillDisappear(animated)
    }
}
