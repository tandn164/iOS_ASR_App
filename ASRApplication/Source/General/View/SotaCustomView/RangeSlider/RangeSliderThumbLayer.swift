//
//  RangeSliderThumbLayer.swift
//

import UIKit
import QuartzCore

class RangeSliderThumbLayer: CAGradientLayer {
    var highlighted: Bool = false {
        didSet {
            if let superLayer = superlayer, highlighted {
                removeFromSuperlayer()
                superLayer.addSublayer(self)
            }
            setNeedsDisplay()
        }
    }
    weak var rangeSlider: AppRangeSlider?
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            let thumbFrame = bounds
            let cornerRadius = thumbFrame.height * slider.curvaceousness / 2
            let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
            self.cornerRadius = cornerRadius
            
            let shadowColor = UIColor.gray
            if (rangeSlider!.thumbHasShadow){
                ctx.setShadow(offset: CGSize(width: 0.0, height: 1.0), blur: 1.0, color: shadowColor.cgColor)
            }
            
            ctx.addPath(thumbPath.cgPath)
            
            ctx.setStrokeColor(shadowColor.cgColor)
            ctx.setLineWidth(slider.thumbBorderThickness)
            ctx.addPath(thumbPath.cgPath)
            ctx.strokePath()
            self.colors = [slider.thumbLayerStartColor.cgColor, slider.thumbLayerEndColor.cgColor]
            self.startPoint = slider.cStartPoint
            self.endPoint = slider.cEndPoint
            
            if highlighted {
                ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
                ctx.addPath(thumbPath.cgPath)
                ctx.fillPath()
            }
        }
    }
}
