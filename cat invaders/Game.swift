//
//  Game.swift
//  cat invaders
//
//  Created by student on 06/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

class Game {
    var score = 0
    var highScore = 0
    
    func saveGame() {
        if score > highScore {
            highScore = score
        }
    }
    
}
