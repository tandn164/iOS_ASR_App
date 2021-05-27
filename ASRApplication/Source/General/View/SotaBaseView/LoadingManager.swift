//
//  LoadingManager.swift
//

import UIKit

class LoadingManager {
    private var loadingView: LoadingAnimation!
    private var isShowing: Bool = true
    private var tapGesture: UITapGestureRecognizer!
    var hidable: Bool = false {
        didSet {
            tapGesture.isEnabled = hidable
        }
    }
    
    static let `default` = LoadingManager()
    
    weak var delegate: LoadingManagerDelegate?
    
    private init() {
        loadingView = LoadingAnimation(frame: UIScreen.main.bounds)
        loadingView.useLargeImage = true
        loadingView.alpha = 0
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tapGesture.isEnabled = false
        loadingView.addGestureRecognizer(self.tapGesture)
    }
    
    func show() {
        isShowing = true
        let window = UIApplication.shared.keyWindow!
        loadingView.frame = window.frame
        window.addSubview(loadingView)
        loadingView.center = window.center
        loadingView.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            [unowned self] in
            self.loadingView.alpha = 1
        }) {
            _ in
            self.delegate?.didShowLoadingView()
        }
    }
    
    func hide() {
        isShowing = false
        UIView.animate(withDuration: 0.2, animations: {
            [unowned self] in
            self.loadingView.alpha = 0
        }) {
            [unowned self] _ in
            self.loadingView.stopAnimating()
            self.loadingView.removeFromSuperview()
            self.delegate?.didHideLoadingView()
        }
    }
    
    func toggle() {
        if isShowing {
            hide()
        }
        else {
            show()
        }
    }
}

private extension LoadingManager {
    @objc func didTap(_ gesture: UIGestureRecognizer) {
        self.hide()
        Toast.overlayToastWith(text: "The proccess is still working")
    }
}

protocol LoadingManagerDelegate: class {
    func didShowLoadingView()
    func didHideLoadingView()
}
