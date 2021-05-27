//ConfirmPopupViewController.swift

import UIKit

enum ConfirmationType {
    case
    logout,
    endLiveStream,
    removeUser,
    freeStyle
}

class ConfirmationData {
    var title: String!
    var message: String!
    var positiveText: String!
    var negativeText: String!
    var type = ConfirmationType.freeStyle

    init(type: ConfirmationType) {
        self.type = type
    }
}

class ConfirmPopupViewController: AppViewController {

    let defaultTitles: [ConfirmationType: String] =  [
        .logout: "lbl_logout".localized,
        .removeUser: "lbl_remove_user".localized,
        .endLiveStream: "txt_end_livestreaming".localized
    ]

    let defaultMessages: [ConfirmationType: String] = [
        .logout: "lbl_logout_confirm".localized,
        .removeUser: "lbl_remove_user_confirm".localized,
        .endLiveStream: "txt_end_livestreaming_confirm".localized
    ]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var confirmationData: ConfirmationData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationData = initData[Constant.ViewParam.confirmationData] as! ConfirmationData
        updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func updateData() {
        let titleKey = confirmationData.title ?? defaultTitles[confirmationData.type] ?? ""
        titleLabel.text = String(format: titleKey)
        let messageKey = confirmationData.message ?? defaultMessages[confirmationData.type] ?? ""
        messageLabel.text = String(format: messageKey)
    }

    @IBAction func onPositiveButtonClicked(sender: AnyObject) {
        switch confirmationData.type {
        default: break
        }
        
        dismissViewController()
    }

}
