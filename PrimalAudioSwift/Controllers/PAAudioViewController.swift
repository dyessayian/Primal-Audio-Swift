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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
        addObservers()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Refresh the collection view when devices (iPad) transition between orientations.
        refreshCollectionView()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Determine the size of the collection view cells.  iPhone devices will display the content within two columns.  iPad devices will display in a 3x4 or 4x3 grid depending on the device orientation.
        let idiom = UIDevice.current.userInterfaceIdiom
        if idiom == .phone {
            // Phone UI will display 2 columns of icons.
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let currentWidth = audioCollectionView.frame.size.width
                let numberOfColumns : CGFloat = 2.0
                let widthToUse = (currentWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right - (CGFloat(numberOfColumns-1) * flowLayout.minimumInteritemSpacing)) / numberOfColumns
                return CGSize(width: widthToUse, height: widthToUse)
            }
        } else {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    let currentWidth = audioCollectionView.frame.size.width
                    let numberOfColumns : CGFloat = 4.0
                    let widthToUse = floor((currentWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right - (CGFloat((numberOfColumns-1)) * flowLayout.minimumInteritemSpacing)) / numberOfColumns)
                    
                    let currentHeight = audioCollectionView.frame.size.height
                    let numberOfRows : CGFloat = 3.0
                    let heightToUse = floor((currentHeight - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - collectionView.safeAreaInsets.top - collectionView.safeAreaInsets.bottom - (CGFloat((numberOfRows-1)) * flowLayout.minimumLineSpacing)) / numberOfRows)
                    
                    return CGSize(width: widthToUse, height: heightToUse)
                }
            } else if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
                if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    let currentWidth = audioCollectionView.frame.size.width
                    let numberOfColumns : CGFloat = 3.0
                    let widthToUse = floor((currentWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right - (CGFloat((numberOfColumns-1)) * flowLayout.minimumInteritemSpacing)) / numberOfColumns)
                    
                    let currentHeight = audioCollectionView.frame.size.height
                    let numberOfRows : CGFloat = 4.0
                    let heightToUse = floor((currentHeight - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - collectionView.safeAreaInsets.top - collectionView.safeAreaInsets.bottom - (CGFloat((numberOfRows-1)) * flowLayout.minimumLineSpacing)) / numberOfRows)
                    
                    return CGSize(width: widthToUse, height: heightToUse)
                }
            }
        }
        return CGSize(width: 100, height: 100)
    }
}
