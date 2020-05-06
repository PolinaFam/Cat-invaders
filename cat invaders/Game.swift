//
//  Game.swift
//  cat invaders
//
//  Created by student on 06/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import Foundation

class Game {
    var score = 0
    var highScore = 0
    
    private var userDefaults = UserDefaults.standard
    
    init() {
        self.highScore = userDefaults.integer(forKey: "highScore")
    }
    
    func saveGame() {
        if score > highScore {
            highScore = score
        }
        userDefaults.set(highScore, forKey: "highScore")
    }
    
}
