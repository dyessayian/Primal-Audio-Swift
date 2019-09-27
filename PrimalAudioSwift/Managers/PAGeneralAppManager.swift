//
//  PAGeneralAppManager.swift
//  PrimalAudioSwift
//
//  Created by Daniel Yessayian on 9/26/19.
//  Copyright © 2019 Daniel Yessayian. All rights reserved.
//

import UIKit

class PAGeneralAppManager: NSObject {

    static let shared = PAGeneralAppManager()
    
    //MARK: - Properties
    var test : String?
    var currentSleepTimer : Timer?
    
    
    //MARK: - Helper Methods
    func setSleepTimer(secondsFromNow : TimeInterval){
    
        // Invalidate existing timer, so only the newest scheduled one takes place.
        currentSleepTimer?.invalidate()
        
        // Schedule the timer to stop all audio after specified number of seconds.
        currentSleepTimer = Timer.scheduledTimer(withTimeInterval: secondsFromNow, repeats: false) { (nil) in
            
            print("Stopping all audio players.")
            
        }
        
    }
    
    
    
}
