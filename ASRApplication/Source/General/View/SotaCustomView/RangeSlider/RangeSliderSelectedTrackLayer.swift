//
//  RangeSliderSelectedTrackLayer.swift
//

import Foundation

import UIKit
import QuartzCore

class RangeSliderSelectedTrackLayer: CAGradientLayer {
    weak var rangeSlider: AppRangeSlider?
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            // Clip
            let cornerRadius = bounds.height * slider.curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)
            
            self.colors = [slider.thumbLayerStartColor.cgColor, slider.thumbLayerEndColor.cgColor]
            self.startPoint = slider.cStartPoint
            self.endPoint = slider.cEndPoint
        }
    }
}
