//
//  BreafCaseInfo.swift
//  DealNoDealGame
//
//  Created by Ajmal Amir on 1/24/24.
//

import Foundation

class BreafCaseInfo{
    let tage: Int
    let suitcaseName: String
    var isFlipped = false
    var isMatched = false
    
    init(tage: Int, suitcaseName: String) {
        self.tage = tage
        self.suitcaseName = suitcaseName
    }
}
