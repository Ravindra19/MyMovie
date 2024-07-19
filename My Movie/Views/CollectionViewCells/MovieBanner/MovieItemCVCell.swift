//
//  MovieItemCVCell.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 02/07/24.
//

import UIKit

class MovieItemCVCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieImage.layer.cornerRadius = 5
    }

}
