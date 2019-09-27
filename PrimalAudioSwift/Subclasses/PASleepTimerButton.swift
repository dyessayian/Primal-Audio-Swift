//
//  PASleepTimerButton.swift
//  PrimalAudioSwift
//
//  Created by Daniel Yessayian on 9/26/19.
//  Copyright © 2019 Daniel Yessayian. All rights reserved.
//

import UIKit

class PASleepTimerButton: UIButton {

    enum ButtonState {
        case active, inactive
    }
    var currentButtonState : ButtonState = .inactive {
        didSet {
            handleCurrentButtonStateUI()
        }
    }
    
    override func awakeFromNib() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }
    
    func handleCurrentButtonStateUI() {
        switch currentButtonState {
        case .active:
            setTitleColor(UIColor(red: 0, green: 106/255, blue: 127/255, alpha: 1.0), for: .normal)
            backgroundColor = UIColor.white
            break
        case .inactive:
            setTitleColor(UIColor.white, for: .normal)
            backgroundColor = UIColor.clear
            break
        }
    }
}
