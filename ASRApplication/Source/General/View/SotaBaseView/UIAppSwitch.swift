//UIAppSwitch.swift

import Foundation
//@IBDesignable
class UIAppSwitch: UIButton {
    @IBInspectable var isOn: Bool = true {
        didSet {
            updateImage()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func initView() {
        cornerRadius = frame.height / 2
        isOn = true
        addTarget(self, action: #selector(UIAppSwitch.onClicked(sender:)), for: .touchUpInside)
    }

    @objc func onClicked(sender: AnyObject) {
        isOn = !isOn
    }

    private func updateImage() {
        let image = isOn ? UIImage(named: "checkBox") : UIImage(named: "checkBoxUnchecked")
        UIView.transition(with: self, duration: 0.1, options: [], animations: {
            self.setImage(image, for: .normal)
        }, completion: nil)
    }
}
