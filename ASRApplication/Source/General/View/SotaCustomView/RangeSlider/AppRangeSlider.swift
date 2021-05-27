//AppRangeSlider.swift

import UIKit
import QuartzCore

enum Knob {
    case neither
    case lower
    case upper
    case both
}
///Class that represents the RangeSlider object.//@IBDesignable
open class AppRangeSlider: UIControl {
    let cStartPoint: CGPoint = CGPoint(x: 0.0, y: 0.5)
    let cEndPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)
    
    @IBInspectable open var thumbLayerStartColor: UIColor = UIColor.blue {
        didSet {
            updateLayerFrames()
        }
    }
    @IBInspectable open var thumbLayerEndColor: UIColor = UIColor.blue {
        didSet {
            updateLayerFrames()
        }
    }
    // MARK: - Properties
    
    ///The minimum value selectable on the RangeSlider
    @IBInspectable open var minimumValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    ///The maximum value selectable on the RangeSlider
    @IBInspectable open var maximumValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    ///The minimum difference in value between the knobs
    @IBInspectable open var minimumDistance: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    ///The current lower value selected on the RangeSlider
    @IBInspectable open var lowerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    ///The current upper value selected on the RangeSlider
    @IBInspectable open var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    ///The color of the track bar outside of the selected range
    @IBInspectable open var trackTintColor: UIColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    ///the thickness of the track bar. `0.1` by default.
    @IBInspectable open var trackThickness: CGFloat = 0.1 {
        didSet {
            updateLayerFrames()
        }
    }
    
    ///The color of the slider buttons. `White` by default.
    @IBInspectable open var thumbTintColor: UIColor = UIColor.white {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    ///The thickness of the slider buttons border. `0.1` by default.
    @IBInspectable open var thumbBorderThickness: CGFloat = 0 {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    ///Whether or not the slider buttons have a shadow. `true` by default.
    @IBInspectable open var thumbHasShadow: Bool = true {
        didSet{
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    ///The curvaceousness of the ends of the track bar and the slider buttons. `1.0` by default.
    @IBInspectable open var curvaceousness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    var previousLocation = CGPoint()
    var previouslySelectedKnob = Knob.neither
    
    let trackLayer = RangeSliderTrackLayer()
    let selectedTrackLayer = RangeSliderSelectedTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    ///The frame of the `RangeSlider` instance.
    override open var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    // MARK: - Lifecycle
    
    /**
     Initializes the `RangeSlider` instance with the specified frame.
     
     - returns: The new `RangeSlider` instance.
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addContentViews()
    }
    
    /**
     Initializes the `RangeSlider` instance from the storyboard.
     
     - returns: The new `RangeSlider` instance.
     */
    required public init(coder: NSCoder) {
        super.init(coder: coder)!
        addContentViews()
    }
    
    func addContentViews(){
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        selectedTrackLayer.rangeSlider = self
        selectedTrackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(selectedTrackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
    }
    
    // MARK: Member Functions
    
    
    ///Updates all of the layer frames that make up the `RangeSlider` instance.
    open func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let newTrackDy = (frame.height - frame.height * trackThickness) / 2
        trackLayer.frame = CGRect(x: 0, y: newTrackDy, width: frame.width, height: frame.height * trackThickness)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter, y: 0.0,
                                       width: self.bounds.height, height: self.bounds.height)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter, y: 0.0,
                                       width: self.bounds.height, height: self.bounds.height)
        upperThumbLayer.setNeedsDisplay()
        
        selectedTrackLayer.frame = CGRect(x: lowerThumbCenter, y: newTrackDy, width: upperThumbCenter - lowerThumbCenter, height: frame.height * trackThickness)
        selectedTrackLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    
    /**
     Returns the position of the knob to be placed on the slider given the value it should be on the slider
     */
    func positionForValue(_ value: Double) -> Double {
        if maximumValue == minimumValue {
            return 0
        }
        
        return Double(bounds.width - bounds.height) * (value - minimumValue) / (maximumValue - minimumValue)
    }
    
    func boundValue(_ value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    /**
     Triggers on touch of the `RangeSlider` and checks whether either of the slider buttons have been touched and sets their `highlighted` property to true.
     
     - returns: A bool indicating if either of the slider buttons were inside of the `UITouch`.
     */
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(previousLocation) && upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = (lowerValue >= minimumValue) && (lowerValue <= (maximumValue - minimumValue) / 3)
            lowerThumbLayer.highlighted = (upperValue <= maximumValue) && (upperValue >= (maximumValue - minimumValue) / 3)
            previouslySelectedKnob = Knob.both
            return true
        }
        
        if lowerThumbLayer.frame.contains(previousLocation) && upperThumbLayer.frame.contains(previousLocation) && (previouslySelectedKnob == Knob.lower || previouslySelectedKnob == Knob.neither) {
            lowerThumbLayer.highlighted = true
            previouslySelectedKnob = Knob.lower
            return true
        }
        
        if lowerThumbLayer.frame.contains(previousLocation) && upperThumbLayer.frame.contains(previousLocation) && previouslySelectedKnob == Knob.upper {
            upperThumbLayer.highlighted = true
            previouslySelectedKnob = Knob.upper
            return true
        }
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
            previouslySelectedKnob = Knob.lower
            return true
        }
        
        if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
            previouslySelectedKnob = Knob.upper
            return true
        }
        
        return false
    }
    
    /**
     Triggers on a continued touch of the `RangeSlider` and updates the value corresponding with the new button location.
     
     - returns: A bool indicating success.
     */
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let value = (maximumValue - minimumValue) * Double(location.x) / Double(bounds.width - bounds.height) + minimumValue
        previousLocation = location
        
        if lowerThumbLayer.highlighted {
            lowerValue = boundValue(value, toLowerValue: minimumValue, upperValue: (upperValue - minimumDistance))
        } else if upperThumbLayer.highlighted {
            upperValue = boundValue(value, toLowerValue: (lowerValue + minimumDistance), upperValue: maximumValue)
        }
        
        sendActions(for: .valueChanged)
        
        return true
    }
    
    /**
     Triggers on the end of touch of the `RangeSlider` and sets the button layers `highlighted` property to `false`.
     */
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
}
