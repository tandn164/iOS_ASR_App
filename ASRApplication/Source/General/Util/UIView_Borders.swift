//
//  UIView+Borders.swift
//  UIViewWithSelectableBorders
//
//  Created by Chris Forant on 5/23/15.
//  Copyright (c) 2015 Totem. All rights reserved.
//

import UIKit

// MARK: - UIView
extension UIView {
    @IBInspectable var round: Bool {
        get {
            return self.bounds.width == self.bounds.height && cornerRadius == self.bounds.width / 2
        }
        set {
            if self.bounds.width == self.bounds.height {
                cornerRadius = self.bounds.width / 2
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            //TODO fix me
            if let subLayers = layer.sublayers {
//                for subLayer in subLayers {
//                    subLayer.cornerRadius = layer.cornerRadius
//                    print(subLayer)
//                  layer.masksToBounds = newValue > 0
//                }

                // default shadow redius and offset
                if layer.shadowRadius == 3 && layer.shadowOffset.height == -3 {
                    layer.masksToBounds = newValue > 0
                }
            } else {
                layer.masksToBounds = newValue > 0
            }
        }
    }
    
    @IBInspectable var topCornersRadius: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            roundCorners(radius: newValue)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var leftBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = UIColor(cgColor: layer.borderColor!)
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    @IBInspectable var topBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }
    
    @IBInspectable var rightBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: bounds.width, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    @IBInspectable var bottomBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }

    @IBInspectable var shadowColor: UIColor {
        get {
            return self.layer.shadowColor != nil ? UIColor(cgColor: self.layer.shadowColor!) : UIColor.clear
        }
        set {
            var red : CGFloat = 0
            var green : CGFloat = 0
            var blue : CGFloat = 0
            var alpha: CGFloat = 0
            newValue.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = Float(alpha)
        }
    }
    
//    @IBInspectable var shadowOpacity: Float {
//        get {
//            return self.layer.shadowOpacity
//        }
//        set {
//            self.layer.shadowOpacity = newValue
//        }
//    }
    
    @IBInspectable var shadowOffset: CGSize {
        get{
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    func roundCorners(radius: CGFloat) {
         if #available(iOS 11.0, *){
             self.clipsToBounds = true
             self.layer.cornerRadius = radius
             self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         }else{
             let rectShape = CAShapeLayer()
             rectShape.bounds = self.frame
             rectShape.position = self.center
             rectShape.path = UIBezierPath(roundedRect: self.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
             self.layer.mask = rectShape
         }
    }
    
    public func addInnerShadow(topColor: UIColor = UIColor.black.withAlphaComponent(0.3)) {
        let shadowLayer = CAGradientLayer()
        shadowLayer.cornerRadius = layer.cornerRadius
        shadowLayer.frame = bounds
        shadowLayer.frame.size.height = 10.0
        shadowLayer.colors = [
            topColor.cgColor,
            UIColor.white.withAlphaComponent(0).cgColor
        ]
        layer.addSublayer(shadowLayer)
    }
    
    func addBottomInnerShadow(bottomColor: UIColor = UIColor.black.withAlphaComponent(0.3)) {
        let shadowLayer = CAGradientLayer()
        shadowLayer.cornerRadius = layer.cornerRadius
        shadowLayer.colors = [
            bottomColor.cgColor,
            UIColor.white.withAlphaComponent(0).cgColor
        ]
        shadowLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        shadowLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        shadowLayer.frame = CGRect(x: 0.0,
                                   y: frame.height - 10,
                                   width: frame.width,
                                   height: 10)

        layer.addSublayer(shadowLayer)
    }
    
}
