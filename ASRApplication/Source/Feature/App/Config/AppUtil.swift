//
//  Util.swift

//
//

import UIKit

// Unsafe delegated method
func associatedObject<ValueType>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
    if let associated = objc_getAssociatedObject(base, key)
        as? ValueType { return associated }
    let associated = initialiser()
    objc_setAssociatedObject(base, key, associated,
                             .OBJC_ASSOCIATION_RETAIN)
    return associated
}

func associateObject<ValueType>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

func += <K, V>(left: inout [K: V], right: [K: V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

func + <K, V>(lhs: [K: V], rhs: [K: V]) -> [K: V] {
    var res: [K: V] = lhs
    res += rhs
    return res
}

extension Util {
    static func getHeadSubSet<T: Comparable>(_ data: [T], count: Int) -> [T] {
        let lastIndex = min(count, data.count)
        return Array(data[0 ..< lastIndex])
    }

    static func getTailSubSet<T: Comparable>(_ data: [T], count: Int) -> [T] {
        guard count <= data.count else { return [] }
        return Array(data[data.count - count ..< data.count])
    }

    static func getSetOfSmall<T: Comparable>(_ data: [T], pivot: T) -> [T] {
        var result = [T]()
        for element in data {
            if element < pivot {
                result.append(element)
            } else {
                break
            }
        }
        return result
    }

    static func getSetOfBig<T: Comparable>(_ data: [T], pivot: T, count: Int) -> [T] {
        var result = [T]()
        // TODO: improve
        for element in data {
            if element <= pivot {
                continue
            }
            if result.count < count {
                result.append(element)
            }
        }
        return result
    }

    static func createBlurImage(source: UIImage, radius: CGFloat = 15) -> UIImage {
        let imageToBlur = CIImage(image: source)
        let blurfilter = CIFilter(name: "CIGaussianBlur")!
        blurfilter.setValue(imageToBlur, forKey: "inputImage")
        blurfilter.setValue(radius, forKey: "inputRadius")
        let resultImage = blurfilter.value(forKey: "outputImage") as! CIImage
        return UIImage(ciImage: resultImage)
    }

    static func formatCurrency(amount: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: amount))!
    }

    static func formatTokens(amount: Int) -> String {
        if amount >= 1000000 {
            let m = Float(amount) / 1000000
            if m < 10 {
                return String(format: "%.2fM", m)
            } else {
                return String(format: "\(Int(m))M")
            }
        } else if amount >= 1000 {
            let k = Float(amount) / 1000
            if k < 10 {
                return String(format: "%.2fK", k)
            } else {
                return String(format: "\(Int(k))K")
            }
        } else {
            return "\(amount)"
        }
    }

    static func formatNumber(_ amount: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: amount))!
//            ?.replacingOccurrences(of: ".", with: ",") ?? "0"
    }

    static func formatDuration(_ duration: Int) -> String {
        var remain = duration / 1000
        let seconds = remain % 60
        remain /= 60
        let minutes = remain % 60
        let hours = remain / 60
        var timeString = ""
        if hours > 0 {
            timeString = String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            timeString = String(format: "%02d:%02d", minutes, seconds)
        }
        return timeString
    }

    static func registerKeyboardEvent(_ observer: Any, showSelector: Selector, hideSelector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: showSelector, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(observer, selector: hideSelector, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    static func removeKeyboardEvent(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(observer, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    static func loadAnimationImages(name: String) -> [UIImage] {
        var images: [UIImage] = []
        if let image = UIImage(named: "\(name)0") {
            images.append(image)
        }
        var index = 1
        while true {
            if let image = UIImage(named: "\(name)\(index)") {
                images.append(image)
                index += 1
            } else {
                break
            }
        }

        return images
    }

    static func loadAnimation(_ name: String, to imageView: UIImageView, frameDuration: Double = 0.1, showLastFrame: Bool = true, repeatCount: Int = 1, completion: (() -> Void)? = nil) {
        imageView.animationRepeatCount = repeatCount
        let animationImages = Util.loadAnimationImages(name: name)
        imageView.animationImages = animationImages
        imageView.animationDuration = frameDuration * Double(animationImages.count)
        if showLastFrame {
            imageView.image = animationImages.last
        }
        imageView.startAnimating()
        Util.delay(imageView.animationDuration, { completion?() })
    }

    static func isValidImage(_ filePath: NSURL) -> Bool {
        let fileStr = filePath.absoluteString?.lowercased() ?? ""
        if fileStr.hasSuffix("jpg") || fileStr.hasSuffix("jpeg") || fileStr.hasSuffix("png") || fileStr.hasSuffix("heic") {
            return true
        }
        return false
    }

    static func getCVPixelBuffer(_ image: CGImage) -> CVPixelBuffer? {
        let imageWidth = Int(image.width)
        let imageHeight = Int(image.height)

        let attributes: [NSObject: AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey: true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true as AnyObject,
        ]

        var pxbuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault,
                            imageWidth,
                            imageHeight,
                            kCVPixelFormatType_32ARGB,
                            attributes as CFDictionary?,
                            &pxbuffer)

        if let _pxbuffer = pxbuffer {
            let flags = CVPixelBufferLockFlags(rawValue: 0)
            CVPixelBufferLockBaseAddress(_pxbuffer, flags)
            let pxdata = CVPixelBufferGetBaseAddress(_pxbuffer)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pxdata,
                                    width: imageWidth,
                                    height: imageHeight,
                                    bitsPerComponent: 8,
                                    bytesPerRow: CVPixelBufferGetBytesPerRow(_pxbuffer),
                                    space: rgbColorSpace,
                                    bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

            if let _context = context {
                _context.draw(image, in: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
            } else {
                CVPixelBufferUnlockBaseAddress(_pxbuffer, flags)
                return nil
            }

            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags)
            return _pxbuffer
        }

        return nil
    }

    // MARK: show toast

    static func showToast(message: String, position: ToastPosition) {
        UIApplication.shared.keyWindow?.makeToast(message, duration: 2.0, position: position)
    }
}

extension Int {
    var boolValue: Bool {
        return self > 0
    }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension Array {
    func reduceWithIndex<T>(initial: T, combine: (T, Int, Array.Iterator.Element) throws -> T) rethrows -> T {
        var result = initial
        for (index, element) in enumerated() {
            result = try combine(result, index, element)
        }
        return result
    }

    /**
     Indicates whether there are any elements in self that satisfy the predicate.
     If no predicate is supplied, indicates whether there are any elements in self.
     */
    func any(_ predicate: (Element) -> Bool = { _ in true }) -> Bool {
        for element in self {
            if predicate(element) {
                return true
            }
        }
        return false
    }

    /**
     Takes an equality comparer and returns a new array containing all the distinct elements.
     */
    func distinct(_ comparer: @escaping (Element, Element) -> Bool) -> [Element] {
        var result = [Element]()
        for t in self {
            // if there are no elements in the result set equal to this element, add it
            if !result.any({ comparer($0, t) }) {
                result.append(t)
            }
        }
        return result
    }
}

extension Data {
    var mimeType: String {
        var c = [UInt8](repeating: 0, count: count)

        copyBytes(to: &c, count: 1)

        switch c.first! {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49, 0x4D:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return "application/octet-stream"
        }
    }
}

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
        timeZone = NSTimeZone.local
    }

    static func date(fromRFC3339 value: String) -> Date? {
        return DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ").date(from: value)
    }
}

extension UIImage {
    var uncompressedPNGData: Data? { return pngData() }
    var highestQualityJPEGNSData: Data? { return jpegData(compressionQuality: 1.0) }
    var highQualityJPEGNSData: Data? { return jpegData(compressionQuality: 0.75) }
    var mediumQualityJPEGNSData: Data? { return jpegData(compressionQuality: 0.5) }
    var lowQualityJPEGNSData: Data? { return jpegData(compressionQuality: 0.25) }
    var lowestQualityJPEGNSData: Data? { return jpegData(compressionQuality: 0.0) }
}

extension TimeInterval {
    var secondToTimeSpan: String {
        let secondsInt = (Int)(self)
        let hours = secondsInt / 3600
        let minutes = (secondsInt % 3600) / 60
        let seconds = (secondsInt % 3600) % 60

        let hoursString = hours > 0 ? "\(hours):" : ""
        let minutesString = minutes < 10 ? (hours > 0 ? "0\(minutes):" : "\(minutes):") : "\(minutes):"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"

        return "\(hoursString)\(minutesString)\(secondsString)"
    }
}

extension UIWindow {
    class func getPresentedViewController<T: UIViewController>(of type: T.Type, base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> T? {
        if base is T {
            return base as? T
        }

        if let nav = base as? UINavigationController {
            return getPresentedViewController(of: T.self, base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getPresentedViewController(of: T.self, base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getPresentedViewController(of: T.self, base: presented)
        }
        return base as? T
    }

    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }

//        if let mediaViewer = base as? AppMediaViewerViewController, let presenter = mediaViewer.self.currentMediaViewController {
//            return getTopMostViewController(base: presenter)
//        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }

        return base
    }
}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
