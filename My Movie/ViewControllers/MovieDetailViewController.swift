//
//  MovieDetailViewController.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 02/07/24.
//

import UIKit
import AVKit
import AVFoundation

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieBannerImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieDiscriptionLabel: UILabel!
    @IBOutlet weak var gener1Button: UIButton!
    @IBOutlet weak var gener2Button: UIButton!
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    var selectedMovie: Movies!
    var allMoviesList: Array<Movies> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        let url = URL(string: selectedMovie.thumb ?? "")!
        movieBannerImage.kf.setImage(with: url)
        movieNameLabel.text = selectedMovie.title
        movieDiscriptionLabel.text = selectedMovie.descriptions
        gener1Button.layer.cornerRadius = gener1Button.frame.height/2
        gener1Button.layer.borderWidth = 1.0
        gener1Button.layer.borderColor = UIColor.white.cgColor
        gener1Button.clipsToBounds = true
        
        gener2Button.layer.cornerRadius = gener2Button.frame.height/2
        gener2Button.layer.borderWidth = 1.0
        gener2Button.layer.borderColor = UIColor.white.cgColor
        gener2Button.clipsToBounds = true
        
        relatedCollectionView.register(UINib.init(nibName: "MovieItemCVCell", bundle: Bundle.main), forCellWithReuseIdentifier: "movieCell")
    }
    
    @IBAction func playAction(_ sender: Any) {
        guard let movieDetailScreenVc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        movieDetailScreenVc.selectedMovie = selectedMovie
        self.navigationController?.pushViewController(movieDetailScreenVc, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.allMoviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieItemCVCell) ?? MovieItemCVCell()
        let url = URL(string: allMoviesList[indexPath.row].thumb ?? "")!
        DispatchQueue.main.async {
            cell.movieImage.kf.setImage(with: url)
        }
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: relatedCollectionView.frame.width/3.2, height: relatedCollectionView.frame.width/2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedMovie = allMoviesList[indexPath.row]
        self.setUpView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
