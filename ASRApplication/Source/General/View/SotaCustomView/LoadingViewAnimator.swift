//
//  AppPullToRefresh.swift
//

import Foundation
import PullToRefresh

class LoadingViewAnimator: RefreshViewAnimator {
    
    fileprivate let refreshView: LoadingAnimation
    
    init(refreshView: LoadingAnimation) {
        self.refreshView = refreshView
    }
    
    func animate(_ state: State) {
        switch state {
        case .initial:
            refreshView.stopAnimating()
        case .releasing(let _):
            refreshView.startAnimating()
        case .loading:
            refreshView.startAnimating()
        default: break
        }
    }
}
