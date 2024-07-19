//
//  PlayerViewController.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 02/07/24.
//

import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController {
    
    var selectedMovie: Movies!
    private var homeScreenVM: HomeScreenViewModel = HomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackButton()
        setUpVideoPlayer()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all // or .landscape, .all, etc.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let windowScreen = self.view.window?.windowScene else { return }
        windowScreen.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeLeft)) { error in
            print(error.localizedDescription)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let windowScreen = self.view.window?.windowScene else { return }
        windowScreen.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
            print(error.localizedDescription)
        }
    }
    
    private func setUpVideoPlayer() {
        guard let videoURL = URL(string: selectedMovie.url ?? "") else {
            print("Invalid video URL")
            return
        }
        
        let player = AVPlayer(url: videoURL)
        self.player = player
        player.play()
        if selectedMovie.lastPlayed > 0 {
            self.seekAlreadyPlayedMovie(time: selectedMovie.lastPlayed)
        }
    }
    
    private func setUpBackButton() {
        let backBtn = UIButton(frame: CGRect(x: 8, y: 30, width: 46, height: 46))
        backBtn.setImage(UIImage(named: "backBtn"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
    }
    
    @objc func backAction() {
        player?.pause()
        _ = self.homeScreenVM.updateSelectedMovie(movie: selectedMovie, lastPlayed: player?.currentTime().value ?? 0)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func seekAlreadyPlayedMovie(time: Int64) {
        let seconds : Int64 = time
        let preferredTimeScale : Int32 = 1000000000
        let maxDuration : CMTime = CMTimeMake(value: seconds, timescale: preferredTimeScale)
        self.player?.seek(to: maxDuration, toleranceBefore: maxDuration, toleranceAfter: maxDuration)
    }
}
