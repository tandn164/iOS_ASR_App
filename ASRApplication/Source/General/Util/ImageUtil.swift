//
//  ImageUtil.swift
//

import Foundation
import Photos

class ImageUtil {
    static func createGradientImage(size: CGSize, startColor: CIColor, endColor: CIColor, startPoint: CGPoint, endPoint: CGPoint) -> UIImage? {

        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        var startVector: CIVector
        var endVector: CIVector

        filter!.setDefaults()


        startVector = CIVector(x: size.width * startPoint.x, y: size.height * startPoint.y)
        endVector = CIVector(x: size.width * endPoint.x, y: size.height * endPoint.y)

        filter!.setValue(startVector, forKey: "inputPoint0")
        filter!.setValue(endVector, forKey: "inputPoint1")
        filter!.setValue(startColor, forKey: "inputColor0")
        filter!.setValue(endColor, forKey: "inputColor1")

        if let outputImage = filter!.outputImage {
            return UIImage(cgImage: context.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: size.width, height: size.height))!)
        } else {
            return nil
        }
    }

    static var contentModes: [UIImageView: UIView.ContentMode] = [:]
    private static func saveContentMode(of imageView: UIImageView) {
        if contentModes[imageView] == nil {
            contentModes[imageView] = imageView.contentMode
        }
    }

    private static func restoreContentMode(of imageView: UIImageView) {
        if let contentMode = contentModes[imageView] {
            imageView.contentMode = contentMode
            contentModes.removeValue(forKey: imageView)
        }
    }

    static func load(_ asset: PHAsset, to imageView: UIImageView, size: CGSize? = nil) {
        let imageSize = size ?? imageView.frame.size

        ImageUtil.saveContentMode(of: imageView)
        let animatedImage = UIImage.animatedImageNamed(Constant.loadingImageName, duration: 0.5)
        imageView.image = animatedImage
        imageView.contentMode = .center

        let imageManager = PHImageManager.default()

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        imageManager.requestImage(for: asset , targetSize: imageSize, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, error) in
            if let image = image {
                imageView.image = image
                ImageUtil.restoreContentMode(of: imageView)
            }
        })
    }

    static func load(_ asset: PHAsset, size: CGSize, completion: ((_ image: UIImage) -> Void)?) {
        let imageManager = PHImageManager.default()

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        imageManager.requestImage(for: asset , targetSize: size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, error) in
            if let image = image {
                completion?(image)
            }
        })
    }
}
