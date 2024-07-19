//
//  HomeScreenViewController.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 01/07/24.
//

import UIKit
import Kingfisher

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    @IBOutlet weak var newReleaseCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    
    private var homeScreenVM: HomeScreenViewModel = HomeScreenViewModel()
    private var allMoviesList: Array<Movies> = []
    var currentCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpView() {
        bannerCollectionView.showsVerticalScrollIndicator = false
        bannerCollectionView.showsHorizontalScrollIndicator = false
        
        bannerCollectionView.register(UINib.init(nibName: "MovieBannerCVCell", bundle: Bundle.main), forCellWithReuseIdentifier: "bannerCell")
        newReleaseCollectionView.register(UINib.init(nibName: "MovieItemCVCell", bundle: Bundle.main), forCellWithReuseIdentifier: "movieCell")
        popularCollectionView.register(UINib.init(nibName: "MovieItemCVCell", bundle: Bundle.main), forCellWithReuseIdentifier: "movieCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeScreenVM.getMovieList(success: { allMovies in
            self.allMoviesList = allMovies
            DispatchQueue.main.async {
                self.bannerCollectionView.reloadData()
                self.newReleaseCollectionView.reloadData()
                self.popularCollectionView.reloadData()
                self.startTimer()
                self.bannerPageControl.numberOfPages = allMovies.count
            }
            
        }, error: { error in
            print(error)
        })
    }
    
    //MARK: Function to update banner after 2 seconds
    private func startTimer() {
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }
    
    @objc func slideToNext() {
        if currentCellIndex < allMoviesList.count-1 {
            currentCellIndex += 1
        } else {
            currentCellIndex = 0
        }
        bannerCollectionView.scrollToItem(at: IndexPath(row: currentCellIndex, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
        bannerPageControl.currentPage = currentCellIndex
    }
    
    private func playVideoAction(selectedMovie: Movies) {
        guard let movieDetailScreenVc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        movieDetailScreenVc.selectedMovie = selectedMovie
        movieDetailScreenVc.allMoviesList = self.allMoviesList
        self.navigationController?.pushViewController(movieDetailScreenVc, animated: true)
    }
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.allMoviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.bannerCollectionView {
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? MovieBannerCVCell) ?? MovieBannerCVCell()
            cell.movieLabel.text = allMoviesList[indexPath.row].title
            let url = URL(string: allMoviesList[indexPath.row].thumb ?? "")!
            DispatchQueue.main.async {
                cell.bannerImageView.kf.setImage(with: url, placeholder: UIImage(named: "card_placeholder"))
            }
            cell.clipsToBounds = true
            return cell
        } else if collectionView == newReleaseCollectionView {
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieItemCVCell) ?? MovieItemCVCell()
            let url = URL(string: allMoviesList[indexPath.row].thumb ?? "")!
            DispatchQueue.main.async {
                cell.movieImage.kf.setImage(with: url, placeholder: UIImage(named: "card_placeholder"))
            }
            cell.clipsToBounds = true
            return cell
        } else {
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieItemCVCell) ?? MovieItemCVCell()
            let url = URL(string: allMoviesList[indexPath.row].thumb ?? "")!
            DispatchQueue.main.async {
                cell.movieImage.kf.setImage(with: url, placeholder: UIImage(named: "card_placeholder"))
            }
            cell.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.bannerCollectionView {
            return  CGSize(width: bannerCollectionView.frame.width, height: bannerCollectionView.frame.height)
        } else if collectionView == newReleaseCollectionView {
            return  CGSize(width: newReleaseCollectionView.frame.width/3, height: newReleaseCollectionView.frame.height)
        } else {
            return  CGSize(width: popularCollectionView.frame.width/3, height: popularCollectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.playVideoAction(selectedMovie: allMoviesList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.bannerCollectionView {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth: CGFloat = flowLayout.itemSize.width
            let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
            var cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
            var collectionWidth = collectionView.frame.size.width
            var totalWidth: CGFloat
            collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
            repeat {
                totalWidth = cellWidth * cellCount + cellSpacing * (cellCount - 1)
                cellCount -= 1
            } while totalWidth >= collectionWidth
            
            if (totalWidth > 0) {
                let edgeInset = (collectionWidth - totalWidth) / 2
                return UIEdgeInsets.init(top: flowLayout.sectionInset.top, left: edgeInset, bottom: flowLayout.sectionInset.bottom, right: edgeInset)
            } else {
                return flowLayout.sectionInset
            }
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
