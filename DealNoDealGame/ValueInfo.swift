//
//  ValueInfo.swift
//  DealNoDealGame
//
//  Created by Ajmal Amir on 1/25/24.
//

import Foundation

class ValueInfo{
    
    let tage: Int
    let valueName: String
    var isFlipped = false
    var isMatched = false
    
    init(tage: Int, sutcaseName: String) {
        self.tage = tage
        self.valueName = sutcaseName
    }
}
