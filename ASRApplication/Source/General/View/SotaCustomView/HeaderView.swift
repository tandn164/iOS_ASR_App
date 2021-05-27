//
//  HeaderView.swift
//

import UIKit

class HeaderView: XibView {
    
    var typeRightBarBottom: Constant.RightBarButtonStyle = .None
    
    @IBOutlet weak var onBackHeaderClicked: UIButton!
    @IBOutlet weak var textTitleHeader: UILabel!
    
    @IBOutlet weak var rightBarBotton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setRinghtBarBottom(style: Constant.RightBarButtonStyle) {
        switch style {
        case .None:
            rightBarBotton.isHidden = true
            typeRightBarBottom = Constant.RightBarButtonStyle.None
            break
        case .Save:
            rightBarBotton.setImage(UIImage(named: "icSave"), for: .normal)
            typeRightBarBottom = Constant.RightBarButtonStyle.Save
            break
        case .Edit:
            rightBarBotton.setImage(UIImage(named: "edit"), for: .normal)
            typeRightBarBottom = Constant.RightBarButtonStyle.Edit
            break
        default:
            break
        }
    }
    
    func setTitleHeader(title: String) {
        self.textTitleHeader.text = title
    }
    
    func hideRightBarButton(enabled: Bool) {
        self.rightBarBotton.isHidden = enabled
    }
    
    
    @IBAction func onBackHeaderClicked(_ sender: UIButton) {
        notifyObservers(.vBack)
    }

    @IBAction func onClicked(_ sender: UIButton) {
        sender.preventRepeatedPresses(inNext: 2)
        switch typeRightBarBottom {
        case Constant.RightBarButtonStyle.None:
            break
        case Constant.RightBarButtonStyle.Save:
            notifyObservers(.vUpdateRightBarBotton)
            break
        case Constant.RightBarButtonStyle.Edit:
            notifyObservers(.vUpdateRightBarBotton)
            break
        default:
            break
        }
    }
}
