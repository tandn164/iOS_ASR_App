//
//  LoadingAnmation.swift
//

import Foundation

class LoadingAnimation: XibView {
    let normalSize = 50
    let largeSize = 90
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    let animatedImage = UIImage.animatedImageNamed(Constant.loadingImageName, duration: 0.5)
    let image = UIImage(named: "cat_loading_1")
    let largeAnimatedImage = UIImage.animatedImageNamed(Constant.largeLoadingImageName, duration: 0.5)
    let largeImage = UIImage(named: "big_cat_loading_1")

    @IBInspectable var useLargeImage: Bool = false {
        didSet {
            if imageView.isAnimating {
                imageView.image = useLargeImage ? largeAnimatedImage : animatedImage
            } else {
                imageView.image = useLargeImage ? largeImage : image
            }
            widthConstraint.constant = CGFloat(useLargeImage ? largeSize : normalSize)
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func initSubviews() {
        super.initSubviews()
        imageView.image = image
    }

    func startAnimating() {
        //imageView.startAnimating()
//        imageView.image = useLargeImage ? largeAnimatedImage : animatedImage
        indicatorView.startAnimating()
    }

    func stopAnimating() {
//        imageView.stopAnimating()
//        imageView.image = useLargeImage ? largeImage : image
        indicatorView.stopAnimating()
    }
}
