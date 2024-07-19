//
//  MovieBannerCVCell.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 01/07/24.
//

import UIKit

class MovieBannerCVCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerImageView.layer.cornerRadius = 5
    }

    @IBAction func playButtonAction(_ sender: Any) {
        print("Play Button Pressed")
    }
}
