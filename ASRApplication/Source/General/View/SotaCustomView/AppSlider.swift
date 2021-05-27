//AppSlider.swift


import Foundation
//@IBDesignable
class AppSlider: XibControl {
    private let beginOffset: CGFloat = 10
    private let endOffset: CGFloat = 10

    @IBOutlet weak var minimumView: UIImageView!
    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var maximumView: UIImageView!
    @IBOutlet weak var thumbPositionConstraint: NSLayoutConstraint!
    var startTouchPosition: CGPoint!
    var startGestureValue: Float!

    var _value: Float = 0
    @IBInspectable var value: Float {
        set {
            if newValue > maximumValue {
                _value = maximumValue
            } else if newValue < minimumValue {
                _value = minimumValue
            } else {
                _value = newValue
            }
            updateThumbPosition()
        }
        get {
            return _value
        }
    }
    @IBInspectable var minimumValue: Float = 0
    @IBInspectable var maximumValue: Float = 100
    @IBInspectable var minImage: UIImage? {
        set {
            minimumView.image = newValue
        }
        get {
            return minimumView.image
        }
    }
    @IBInspectable var maxImage: UIImage? {
        set {
            maximumView.image = newValue
        }
        get {
            return maximumView.image
        }
    }
    @IBInspectable var minColor: UIColor {
        set {
            minimumView.backgroundColor = newValue
        }
        get {
            return minimumView.backgroundColor ?? UIColor.clear
        }
    }
    @IBInspectable var maxColor: UIColor {
        set {
            maximumView.backgroundColor = newValue
        }
        get {
            return maximumView.backgroundColor ?? UIColor.clear
        }
    }

    private func updateThumbPosition() {
        guard maximumValue > minimumValue else {
            thumbPositionConstraint.constant = contentView.frame.width - endOffset
            return
        }
        
        let percent = value / (maximumValue - minimumValue)
        let width = contentView.frame.width - beginOffset - endOffset
        let realX = width * CGFloat(percent) + beginOffset
        thumbPositionConstraint.constant = realX
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateThumbPosition()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        sendActions(for: .touchDown)
        startTouchPosition = touch.location(in: self)
        startGestureValue = value
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        guard let startTouchPosition = startTouchPosition else {
            return
        }
        let position = touch.location(in: self)
        updateSliderValue(startPosition: startTouchPosition, currentPosition: position)
        sendActions(for: .touchDragInside)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        guard let startTouchPosition = startTouchPosition else {
            return
        }
        let position = touch.location(in: self)
        updateSliderValue(startPosition: startTouchPosition, currentPosition: position)
        sendActions(for: .touchUpInside)
        self.startTouchPosition = nil
    }

    func updateSliderValue(startPosition: CGPoint, currentPosition: CGPoint) {
        let dx = currentPosition.x - startTouchPosition.x
        let width = contentView.frame.width - beginOffset - endOffset
        let dv = dx / width * CGFloat(maximumValue - minimumValue)
        var newValue = startGestureValue + Float(dv)
        if newValue < minimumValue {
            newValue = minimumValue
        }
        if newValue > maximumValue {
            newValue = maximumValue
        }
        value = newValue
        sendActions(for: .valueChanged)
    }
}
