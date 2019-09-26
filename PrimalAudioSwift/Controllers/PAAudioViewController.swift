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
    var audioObjectsArray = [PAAudioObject]()
    var audioPlayersArray = [AVAudioPlayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //audioCollectionView.canCancelContentTouches = true
        audioCollectionView.delaysContentTouches = true
        
        
        // Do any additional setup after loading the view.
        setupAudioObjects()
        createAudioPlayers()
        setupCollectionView()
    }
    
    private func setupAudioObjects() {
        
        let beachObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Beach_On"), backgroundImage: UIImage(named: "DYaudio_Beach_Off"), audioFileName: "beach")
        let creekObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Creek_On"), backgroundImage: UIImage(named: "DYaudio_Creek_Off"), audioFileName: "creek")
        let fireObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Fire_On"), backgroundImage: UIImage(named: "DYaudio_Fire_Off"), audioFileName: "fire")
        let forestObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Forest_On"), backgroundImage: UIImage(named: "DYaudio_Forest_Off"), audioFileName: "forest")
        let fountainObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Fountain_On"), backgroundImage: UIImage(named: "DYaudio_Fountain_Off"), audioFileName: "fountain")
        let rainObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Rain_On"), backgroundImage: UIImage(named: "DYaudio_Rain_Off"), audioFileName: "rain")
        let rainRoofObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Flood_On"), backgroundImage: UIImage(named: "DYaudio_Flood_Off"), audioFileName: "rainroof")
        let snowstormObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Snowstorm_On"), backgroundImage: UIImage(named: "DYaudio_Snowstorm_Off"), audioFileName: "snowstorm")
        let thunderObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Thunder_On"), backgroundImage: UIImage(named: "DYaudio_Thunder_Off"), audioFileName: "thunder")
        let windInLeavesObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_WindLeaves_On"), backgroundImage: UIImage(named: "DYaudio_WindLeaves_Off"), audioFileName: "windinleaves")
        let windChimesObject = PAAudioObject(mainImage: UIImage(named: "DYaudio_Windchimes_On"), backgroundImage: UIImage(named: "DYaudio_Windchimes_Off"), audioFileName: "windchimes")
        let settingsObject = PAAudioObject(mainImage: UIImage(named: "settings"), backgroundImage: UIImage(named: "settings"), audioFileName: nil)
        audioObjectsArray.append(contentsOf: [beachObject, creekObject, fireObject, forestObject, fountainObject, rainObject, rainRoofObject, snowstormObject, thunderObject, windInLeavesObject, windChimesObject, settingsObject])
        refreshTable()
    }
    
    private func createAudioPlayers() {
        //Create an audio player for each sound in the application:
        //var audioPlayersArray = [AVAudioPlayer]()
        audioObjectsArray.forEach { audioObject in
            if let audioFileName = audioObject.audioFileName, !audioFileName.isEmpty {
                print("Creating audio player for: \(audioFileName)")
                
                if let audioResource = Bundle.main.path(forResource: audioFileName, ofType: "mp3"){
                    
                    print("Audio resource: \(audioResource)")
                    
                    do {
                        let audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioResource))
                        print("Got audio player.")
                        audioPlayer.delegate = self
                        audioPlayer.numberOfLoops = -1
                        audioPlayersArray.append(audioPlayer)
                    } catch {
                        print("Failed to load file into AVAudioPlayer.")
                    }
                } else {
                    print("Couldn't retrieve audio resource.")
                }
            }
        }
    }
    
    private func handlePlayingAudioObject(audioObject : PAAudioObject, index : Int){
        print("Handling audio playback.")
        let matchingAVPlayer = audioPlayersArray[index]
        if audioObject.currentVolume <= 0.0 {
            matchingAVPlayer.stop()
        } else {
            matchingAVPlayer.play()
            matchingAVPlayer.volume = Float(audioObject.currentVolume)
        }
    }
    
    private func refreshTable() {
        DispatchQueue.main.async {
            self.audioCollectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        audioCollectionView.register(UINib(nibName: "PAAudioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PAAudioCollectionViewCell")
    }
    
    @IBAction func tempShowSettingsButtonPressed(_ sender: UIButton) {
        print("Showing settings")
        
    }
}

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
        return audioObjectsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PAAudioCollectionViewCell", for: indexPath) as! PAAudioCollectionViewCell
        cell.delegate = self
        cell.audioVolumeToggleButton.tag = indexPath.row
        cell.setupUI(fromAudioObject: audioObjectsArray[indexPath.row])
        return cell
    }
}

extension PAAudioViewController : PAAudioCollectionViewCellDelegate {
    func toggleVolumeButtonPressed(cell: PAAudioCollectionViewCell, sender: UIButton) {
        print("Toggle volume: \(sender.tag)")
        let editingAudioObject = audioObjectsArray[sender.tag]
        editingAudioObject.toggleVolume()
        refreshTable()
        print("Audio Object volume now at: \(editingAudioObject.currentVolume)")
        
        guard let audioFileName = editingAudioObject.audioFileName, !audioFileName.isEmpty else { return }
        handlePlayingAudioObject(audioObject: editingAudioObject, index: sender.tag)
    }
}

extension PAAudioViewController : AVAudioPlayerDelegate {
    
}
