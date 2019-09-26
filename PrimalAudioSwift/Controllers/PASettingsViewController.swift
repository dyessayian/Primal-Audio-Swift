//
//  PASettingsViewController.swift
//  PrimalAudioSwift
//
//  Created by Daniel Yessayian on 9/24/19.
//  Copyright © 2019 Daniel Yessayian. All rights reserved.
//

import UIKit

class PASettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Settings loaded.")
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
