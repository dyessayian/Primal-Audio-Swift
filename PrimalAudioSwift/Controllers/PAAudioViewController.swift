//
//  PAAudioViewController.swift
//  PrimalAudioSwift
//
//  Created by Daniel Yessayian on 9/24/19.
//  Copyright © 2019 Daniel Yessayian. All rights reserved.
//

import UIKit
import AVFoundation

class PAAudioViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var audioCollectionView: UICollectionView!
    
    //MARK: - Properties
//    var audioObjectsArray = [PAAudioObject]()
//    var audioPlayersArray = [AVAudioPlayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
        addObservers()
    }
    
    //MARK: - Helper Methods
    private func performInitialSetup() {
        
        // Create the audio objects and AVPlayers:
        PAGeneralAppManager.shared.setupAudio()
        
        // Register the nib for the collection view.
        audioCollectionView.register(UINib(nibName: "PAAudioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PAAudioCollectionViewCell")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCollectionView), name: NSNotification.Name("SleepTimerTriggered"), object: nil)
    }
    
    @objc private func refreshCollectionView() {
        DispatchQueue.main.async {
            self.audioCollectionView.reloadData()
        }
    }
    
    private func handlePlayingAudioObject(audioObject : PAAudioObject, index : Int){
        // Play, stop, or adjust the volume of the matching AVPlayer:
        let matchingAVPlayer = PAGeneralAppManager.shared.audioPlayersArray[index]
        if audioObject.currentVolume <= 0.0 {
            matchingAVPlayer.stop()
        } else {
            matchingAVPlayer.play()
            matchingAVPlayer.volume = Float(audioObject.currentVolume)
        }
    }
}

//MARK: - UICollectionView Methods
extension PAAudioViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Portrait:
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let currentWidth = audioCollectionView.frame.size.width
            let widthToUse = (currentWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing) / 2.0
            return CGSize(width: widthToUse, height: widthToUse)
        }
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PAGeneralAppManager.shared.audioObjectsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PAAudioCollectionViewCell", for: indexPath) as! PAAudioCollectionViewCell
        cell.setupUI(fromAudioObject: PAGeneralAppManager.shared.audioObjectsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Retrieve the matching selected audio object
        let selectedAudioObject = PAGeneralAppManager.shared.audioObjectsArray[indexPath.item]
        
        if let audioFileName = selectedAudioObject.audioFileName, !audioFileName.isEmpty {
            // Selected an audio file.  The volume will decrease by 25% until off.  If on, it will be turned on to 100%.
            selectedAudioObject.toggleVolume()
            refreshCollectionView()
            handlePlayingAudioObject(audioObject: selectedAudioObject, index: indexPath.item)
        } else {
            // Selected settings icon.  Will perform modal segue to the settings screen.
            performSegue(withIdentifier: "settingsSegue", sender: nil)
        }
    }
}

