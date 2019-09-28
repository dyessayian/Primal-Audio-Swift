//
//  PAGeneralAppManager.swift
//  PrimalAudioSwift
//
//  Created by Daniel Yessayian on 9/26/19.
//  Copyright © 2019 Daniel Yessayian. All rights reserved.
//

import UIKit
import AVFoundation

class PAGeneralAppManager: NSObject {

    //MARK: - Properties
    static let shared = PAGeneralAppManager()
    var audioObjectsArray = [PAAudioObject]()
    var audioPlayersArray = [AVAudioPlayer]()
    private var currentSleepTimer : Timer?
    private var countDownTimer : Timer?
    private var remainingTime : Int = 0
    
    
    //MARK: - Helper Methods
    func setupAudio() {
        createAudioObjectsArray()
        createAudioPlayersArray(withAudioObjectsArray: audioObjectsArray)
    }
    
    func setSleepTimer(secondsFromNow : TimeInterval){
    
        // Invalidate existing timer, so only the newest scheduled one takes place.
        currentSleepTimer?.invalidate()
        countDownTimer?.invalidate()
        remainingTime = Int(secondsFromNow)
        NotificationCenter.default.post(name: NSNotification.Name("CountdownTimerTriggered"), object: nil, userInfo: ["RemainingTime":self.remainingTime])
        
        // Schedule the sleep timer to stop all audio after specified number of seconds.
        currentSleepTimer = Timer.scheduledTimer(withTimeInterval: secondsFromNow, repeats: false) { (nil) in
            print("Sleep timer triggered.")
            self.resetData()
        }
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            print("Countdown timer tick.")
            self.remainingTime = self.remainingTime - 1
            NotificationCenter.default.post(name: NSNotification.Name("CountdownTimerTriggered"), object: nil, userInfo: ["RemainingTime":self.remainingTime])
        })
    }
    
    private func resetData(){
        
        // Stop all audio players, reset volume, and trigger UI refresh.
        self.audioPlayersArray.forEach {
            $0.stop()
        }
        self.audioObjectsArray.forEach {
            $0.currentVolume = 0.0
        }
        self.countDownTimer?.invalidate()
        NotificationCenter.default.post(name: NSNotification.Name("SleepTimerTriggered"), object: nil, userInfo: nil)
        
        self.remainingTime = 0
        NotificationCenter.default.post(name: NSNotification.Name("CountdownTimerTriggered"), object: nil, userInfo: ["RemainingTime":self.remainingTime])
    }
    
    //func createAudioObjectsArray() -> [PAAudioObject] {
    func createAudioObjectsArray() {
        
        // Create the audio objects and return them in an array to populate the audio collection view.
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
        self.audioObjectsArray = [beachObject, creekObject, fireObject, forestObject, fountainObject, rainObject, rainRoofObject, snowstormObject, thunderObject, windInLeavesObject, windChimesObject, settingsObject]
    }
    
    //func createAudioPlayersArray(withAudioObjectsArray audioObjectsArray : [PAAudioObject]) -> [AVAudioPlayer] {
    func createAudioPlayersArray(withAudioObjectsArray audioObjectsArray : [PAAudioObject]) {
        
        // Create the audio players to allow multiple audio sounds to play concurrently.
        
        var audioPlayersArray = [AVAudioPlayer]()
        //Create an audio player for each sound in the application:
        audioObjectsArray.forEach { audioObject in
            if let audioFileName = audioObject.audioFileName, !audioFileName.isEmpty {
                //print("Creating audio player for: \(audioFileName)")
                
                if let audioResource = Bundle.main.path(forResource: audioFileName, ofType: "mp3"){
                    //print("Audio resource: \(audioResource)")
                    do {
                        let audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioResource))
                        //print("Got audio player.")
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
        self.audioPlayersArray = audioPlayersArray
    }
}
