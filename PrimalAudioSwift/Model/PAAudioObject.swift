//
//  PAAudioObject.swift
//  PrimalAudioSwift
//
//  Created by Daniel Yessayian on 9/24/19.
//  Copyright © 2019 Daniel Yessayian. All rights reserved.
//

import Foundation
import UIKit

class PAAudioObject {
    
    //MARK: - Properties
    let mainImage : UIImage?
    let backgroundImage : UIImage?
    let audioFileName : String?
    var currentVolume : CGFloat
    
    init(mainImage : UIImage?, backgroundImage : UIImage?, audioFileName : String?) {
        self.mainImage = mainImage
        self.backgroundImage = backgroundImage
        self.audioFileName = audioFileName
        self.currentVolume = 0.0
    }
    
    //MARK: - Helpers
    func toggleVolume() {
        if currentVolume.isEqual(to: 0.0){
            currentVolume = 1.0
        } else {
            currentVolume = currentVolume - 0.25
        }
    }
}
