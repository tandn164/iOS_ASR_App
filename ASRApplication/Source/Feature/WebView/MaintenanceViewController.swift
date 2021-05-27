//MaintananceViewController.swift

import Foundation
import WebKit

class MaintenanceViewController: AppViewController {
    
    @IBOutlet weak var webviewContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebview()
        let error = initData[Constant.ViewParam.error] as! Error
        titleLabel.text = error.localizedDescription
        let url = String(format: Constant.serverErrorUrl, error.code)
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    @nonobjc
    override func update(_ command: Command, data: Any?) {
        switch command {
        case .gApplicationDidBecomeActive:
            let vc = Util.createViewController(
                storyboardName: AppConfig.storyboardName,
                id: Constant.ViewController.mainNavigation)
            UIApplication.shared.keyWindow?.set(rootViewController: vc)
        default:
            super.update(command, data: data)
        }
    }
    
    func setupWebview() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.frame = CGRect.init(x: 0, y: 0, width: webviewContainer.frame.width, height: webviewContainer.frame.height)
        let topConstraint = NSLayoutConstraint(item: webView!, attribute: .top, relatedBy: .equal, toItem: webviewContainer, attribute: .top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: webView!, attribute: .leading, relatedBy: .equal, toItem: webviewContainer, attribute: .leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: webView!, attribute: .trailing, relatedBy: .equal, toItem: webviewContainer, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: webView!, attribute: .bottom, relatedBy: .equal, toItem: webviewContainer, attribute: .bottom, multiplier: 1, constant: 0)
        webView.scrollView.backgroundColor = .white
        webView.backgroundColor = .white
        webView.isOpaque = false
        webviewContainer.addSubview(webView)
        webviewContainer.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        
    }
}
