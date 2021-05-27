//
//  LoadingCollectionViewCell.swift
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func endLoading() {
        activityIndicator.stopAnimating()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
