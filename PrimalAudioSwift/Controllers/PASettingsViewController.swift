//
//  PASettingsViewController.swift
//  PrimalAudioSwift
//
//  Created by Daniel Yessayian on 9/24/19.
//  Copyright © 2019 Daniel Yessayian. All rights reserved.
//

import UIKit

class PASettingsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var sleepTimerLabel: UILabel!
    @IBOutlet var sleepTimerButtonCollection: [PASleepTimerButton]!
    
    //MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Settings loaded.")
        
        sleepTimerButtonCollection.forEach({$0.currentButtonState = .inactive})
        
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sleepTimerTimeButtonPressed(_ sender: PASleepTimerButton) {
        print("Setting sleep timer to \(sender.tag) seconds.")
        sleepTimerButtonCollection.forEach({$0.currentButtonState = .inactive})
        sender.currentButtonState = .active
        
        let timeInterval = TimeInterval(sender.tag)
        PAGeneralAppManager.shared.setSleepTimer(secondsFromNow: timeInterval)
        
        
        
    }
}
