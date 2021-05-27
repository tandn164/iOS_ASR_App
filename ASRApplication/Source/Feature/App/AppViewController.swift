//AppViewController.swift

import UIKit
import SDWebImage

class AppViewController: BaseViewController, AppObserver {
    let globalDataController = ControllerFactory.globalDataController

    @IBOutlet weak var appHeader: HeaderView!
    @IBOutlet weak var appScreen: AppScreen!
    @IBOutlet weak var bottomMarginConstraint: NSLayoutConstraint!

    var statusBarStyle: UIStatusBarStyle = .default
    private(set) var isKeyboardShowing: Bool = false
    private(set) var keyboardHeight: CGFloat = 0
    var notiCount: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        view.onUpdateLocale()
    }
    
    func setTitleHeader(title: String) {
        if(appHeader != nil) {
            appHeader.setTitleHeader(title: title)
        }
    }

    func setRinghtBarBottom(enabled: Bool, style: Constant.RightBarButtonStyle) {
        if(appHeader != nil) {
            appHeader.hideRightBarButton(enabled: enabled)
            appHeader.setRinghtBarBottom(style: style)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let appScreen = appScreen {
            addView(appScreen)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    public override func update(_ command: Int, data: Any?) {
        DispatchQueue.main.async {
            [weak self] in
            self?.update(Command(rawValue: command)!, data: data)
        }
    }
    
    @nonobjc
    func update(_ command: Command, data: Any?) {
        switch command {
        case .vShowError:
            //Todo: Should replace UI
            if let message = data as? String {
                Toast.overlayToastWith(text: message)
            }
            break
        case .vShowNetworkError:
            showAlert(title: "txt_network_error_title".localized,
                      message: "txt_network_error_message".localized)
            break
        case .vDismissViewController:
            dismissViewController()
            break
        default:
            break
        }
    }

    override func showViewController(_ id: String, data: [String: Any] = [String: Any](), delegate: ViewControllerDelegate? = nil, from: UIViewController? = nil) {
        dismissKeyboard()
        super.showViewController(id, data: data, delegate: delegate, from: from)
    }

    override func showDialog(_ id: String, data: [String: Any] = [String: Any](), delegate: ViewControllerDelegate? = nil) {
        dismissKeyboard()
        super.showDialog(id, data: data, delegate: delegate)
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.dismissViewController()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        isKeyboardShowing = true
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardFrame.height
            keyboardWillShow(keyboardSize: keyboardFrame.size)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        isKeyboardShowing = false
        keyboardWillHide()
    }
    
    func keyboardWillShow(keyboardSize: CGSize) {
        UIView.animate(withDuration: 1, animations: {
            if let bottomMarginConstraint = self.bottomMarginConstraint {
                bottomMarginConstraint.constant = keyboardSize.height
            }
        })
    }
    
    func keyboardWillHide() {
        UIView.animate(withDuration: 1, animations: {
            if let bottomMarginConstraint = self.bottomMarginConstraint {
                bottomMarginConstraint.constant = 0
            }
        })
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension AppViewController {
    func openManageSubscription() {
        UIApplication.shared.openURL(URL(string: "itms-apps://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions")!)
    }

    func openAppStore() {
        //TODO change appid
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/1210298442")!)

    }
}
