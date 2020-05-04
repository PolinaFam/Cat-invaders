//
//  GameViewController.swift
//  cat invaders
//
//  Created by student on 04/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var score = 0
    
    @IBOutlet weak var spaceShip: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScoreLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: view)
            
            if(location.x < view.frame.size.width/2){
                moveShipToLeft(xCoordinates: location.x)
            } else {
                moveShipToRight(xCoordinates: location.x)
            }
        }
    }
    
    func moveShipToLeft(xCoordinates: CGFloat){
        if (spaceShip.center.x > 65) {
            spaceShip.center.x -= 15
        }
    }
    
    func moveShipToRight(xCoordinates: CGFloat){
        if (spaceShip.center.x < UIScreen.main.bounds.width - 65) {
            spaceShip.center.x += 15
        }
    }
    
    func updateScoreLabel(){
        scoreLabel.text = String(score)
    }
}
