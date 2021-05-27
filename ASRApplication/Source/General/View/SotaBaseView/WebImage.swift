//
//  WebImage.swift

//
//

import Foundation
import UIKit
import SDWebImage
import Photos

extension UIImageView {
//    func setImage(with url: URL!) {
//        self.sd_setImage(with: url)
//    }
//    
//    func setAvatar(with url: URL!) {
//        self.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultAvatar"))
//    }

    func setImage(with url: String, usePlaceHolder: Bool = false) {
        let url = URL(string: url)
        if usePlaceHolder {
            self.sd_setImage(with: url, placeholderImage: UIImage(named: "imagePlaceholder"), options: [.retryFailed], completed: { image, error, _, _ in
                self.image = image ?? UIImage(named: "imagePlaceholder")
            })
        } else {
            self.sd_setImage(with: url)
        }
    }

//    func setImage(with url: String, completed: SDWebImage.SDWebImageCompletionBlock!) {
//        let url = URL(string: url)
//        if SDWebImageManager.shared().cachedImageExists(for: url) {
//            self.sd_setImage(with: url)
//        } else {
//            self.sd_setImage(with: url, placeholderImage: UIImage(named: "imagePlaceholder"), options: [], completed: { image, error, _, _ in
//                self.image = image ?? UIImage(named: "imagePlaceholder")
//                completed(
//            })
//        }
//    }

    func setAvatar(with url: String, placeHolder: UIImage? = UIImage(named: "defaultAvatar")) {
        if url.isEmpty {
            self.image = placeHolder
            return
        }

        if !url.hasPrefix("http") {
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [url], options: nil).firstObject {
                ImageUtil.load(asset, to: self)
            }
            return
        }

        let url = URL(string: url)
        self.sd_setImage(with: url, placeholderImage: placeHolder, options: [.retryFailed], completed: { image, error, _, _ in
            self.image = image ?? placeHolder
        })
    }
    
    func setBackground(with url: String) {
        if url.isEmpty {
            self.image = UIImage(named: "defaultBackground")
            return
        }

        if !url.hasPrefix("http") {
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [url], options: nil).firstObject {
                ImageUtil.load(asset, to: self)
            }
            return
        }

        let url = URL(string: url)
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultBackground"), options: [.retryFailed], completed: { image, error, _, _ in
            self.image = image ?? UIImage(named: "defaultBackground")
        })
    }
    
}
