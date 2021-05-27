//
//  RepositoryUtil.swift
//

import Foundation

class RepositoryUtil {
    static func onError(_ error: Error) {
        switch error.code {
        case 401: // Unauthorized
            print("Unauthorized")
        case 503, 426: // server mantenance, force update
            DispatchQueue.main.async {
                let data = [Constant.ViewParam.error: error]
                BaseViewController.showRootViewController(Constant.ViewController.maintenance, data: data)
            }
        default:
            break
        }
    }
}
