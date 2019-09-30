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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Default button UI state to inactive.
        sleepTimerButtonCollection.forEach({$0.currentButtonState = .inactive})
        
        addObservers()
    }
    
    //MARK: - Observers
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCountdownLabelText(notification:)), name: NSNotification.Name(rawValue: "CountdownTimerTriggered"), object: nil)
    }
    
    @objc private func refreshCountdownLabelText(notification : NSNotification) {
        guard let userInfoDict = notification.userInfo else { return }
        guard let timeRemaining = userInfoDict["RemainingTime"] as? Int else { return }
        sleepTimerLabel.text = timeRemaining.remainingTimeString()
    }
    
    //MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sleepTimerTimeButtonPressed(_ sender: PASleepTimerButton) {
        // Deselect other sleep timer buttons, and set the selected one to active.
        sleepTimerButtonCollection.forEach({$0.currentButtonState = .inactive})
        sender.currentButtonState = .active
        
        // Setup a sleep timer to trigger after X seconds (based on the tag property set on the buttons).
        PAGeneralAppManager.shared.setSleepTimer(secondsFromNow: TimeInterval(sender.tag))
    }
}
