//Numeric+Extension.swift

import UIKit

public func VW(_ phoneX: CGFloat, _ padX: CGFloat? = nil) -> CGFloat {
    if Device.current.isPad {
        return (padX ?? phoneX) * Device.current.vwScale
    }
    return phoneX * Device.current.vwScaleIphoneX
}

public func VH(_ phoneY: CGFloat, _ padY: CGFloat? = nil) -> CGFloat {
    if Device.current.isPad {
        return (padY ?? phoneY) * Device.current.vhScale
    }
    return phoneY * Device.current.vhScaleIphoneX
}

extension SignedInteger {
    /// 10 Number of digits
    var digitCount: Int {
        var tmp = abs(self) / 10
        var count: Int = 1
        while tmp > 0 {
            tmp /= 10
            count += 1
        }
        return count
    }
}

extension BinaryFloatingPoint {
    /// Stretch in proportion to the reference screen width
    var vw: CGFloat {
        get {
            return VW(CGFloat(self))
        }
    }

    /// Stretch in proportion to the reference screen width (for iPad, stretch by 1.5 times the screen width)
    var w: CGFloat {
        get {
            return VW(CGFloat(self), CGFloat(self) * 1.5)
        }
    }

    /// Stretches in proportion to the height of the standard reference screen
    var vh: CGFloat {
        get {
            return VH(CGFloat(self))
        }
    }
    /// Stretch in proportion to the height of the standard reference screen (for iPad, stretch by 1.5 times the height of the screen)
    var h: CGFloat {
        get {
            return VH(CGFloat(self), CGFloat(self) * 1.5)
        }
    }
}

extension TimeInterval {
    var milliseconds: Int64 {
        get {
            return Int64(self * 1000)
        }
    }

    func dateString(format :String) -> String {
        let date = Date(timeIntervalSince1970: self)
        return date.dateString(format: format)
    }
}

extension Date {
    func dateString(format :String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Int {
    var isSuccess: Bool {
        get {
            return self == 1
        }
    }
}

