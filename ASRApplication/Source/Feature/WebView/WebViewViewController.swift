//WebViewViewController.swift

import Foundation
import WebKit

class WebViewViewController: AppViewController {
    @IBOutlet weak var webviewContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebview()

        let title = initData[Constant.ViewParam.title] as! String
        titleLabel.text = title
        let url = initData[Constant.ViewParam.url] as! String
        webView.load(URLRequest(url: URL(string: url)!))
    }


    @IBAction override func onBack(_ sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.dismissViewController()
        }
    }
    
    func setupWebview() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.frame = CGRect.init(x: 0, y: 0, width: webviewContainer.frame.width, height: webviewContainer.frame.height)
        webView.scrollView.backgroundColor = .white
        webView.backgroundColor = .white
        webView.isOpaque = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        let topConstraint = NSLayoutConstraint(item: webView!, attribute: .top, relatedBy: .equal, toItem: webviewContainer, attribute: .top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: webView!, attribute: .leading, relatedBy: .equal, toItem: webviewContainer, attribute: .leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: webView!, attribute: .trailing, relatedBy: .equal, toItem: webviewContainer, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: webView!, attribute: .bottom, relatedBy: .equal, toItem: webviewContainer, attribute: .bottom, multiplier: 1, constant: 0)
        webviewContainer.addSubview(webView)
        webviewContainer.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
    }
}

extension WebViewViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        Toast.overlayToastWith(text: "lbl_connecting".localized)
    }
}
