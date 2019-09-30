//
//  Int+Extensions.swift
//  PrimalAudioSwift
//
//  Created by Daniel Yessayian on 9/27/19.
//  Copyright © 2019 Daniel Yessayian. All rights reserved.
//

import Foundation

extension Int {
    func remainingTimeString() -> String {
        let hours = self / 3600
        let minutes = (self / 60) % 60
        let seconds = self % 60
        return String(format: "%0.1d:%0.2d:%0.2d", hours, minutes, seconds)
    }
}
