//
//  PAAudioCollectionViewCell.swift
//  PrimalAudioSwift
//
//  Created by Daniel Yessayian on 9/24/19.
//  Copyright © 2019 Daniel Yessayian. All rights reserved.
//

import UIKit

protocol PAAudioCollectionViewCellDelegate {
    func toggleVolumeButtonPressed(cell : PAAudioCollectionViewCell, sender : UIButton)
}

class PAAudioCollectionViewCell: UICollectionViewCell {

    //Delegate
    var delegate : PAAudioCollectionViewCellDelegate?

    //MARK: - Outlets
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var audioBackgroundImageView: UIImageView!
    @IBOutlet weak var audioVolumeToggleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    //MARK: - Helpers
    func setupUI(fromAudioObject audioObject : PAAudioObject){
        self.audioImageView.image = audioObject.mainImage
        self.audioBackgroundImageView.image = audioObject.backgroundImage
        
        //print("Setting alpha to: \(audioObject.currentVolume)")
        audioImageView.alpha = audioObject.currentVolume
    }
    
    //MARK: - Actions
    @IBAction func toggleVolumeButtonPressed(_ sender: UIButton) {
        delegate?.toggleVolumeButtonPressed(cell: self, sender: sender)
    }
    
}
