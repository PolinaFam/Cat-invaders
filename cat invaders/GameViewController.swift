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
    var spaceShipShootCd = 25
    var spaceShipBullets = [UIImageView]()
    
    @IBOutlet weak var spaceShip: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScoreLabel()
        startTimer()
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
    
    func fireBullet() {
        spaceShipShootCd += 1
        
        if spaceShipShootCd >= 25 {
            let bulletFrame = CGRect(
                x: spaceShip.frame.origin.x + spaceShip.frame.width * 0.45,
                y: spaceShip.frame.origin.y - spaceShip.frame.height * 0.2,
                width: spaceShip.frame.width * 0.1,
                height: spaceShip.frame.height * 0.2)
            let newBullet = UIImageView(frame: bulletFrame)
            newBullet.image = #imageLiteral(resourceName: "bullet")
            view.addSubview(newBullet)
            spaceShipBullets.append(newBullet)
            spaceShipShootCd = 0
        }
    }
    
    func doMove(){
        for (number, item) in spaceShipBullets.enumerated() {
            item.frame.origin.y -= 10
            if item.frame.origin.y < -item.frame.height {
                spaceShipBullets[number].removeFromSuperview()
                spaceShipBullets.remove(at: number)
            }
        }
    }
    
    @objc func startTimer(){
        let start = mach_absolute_time()
        
        fireBullet()
        doMove()
        
        let end = mach_absolute_time()
        let time = Double(start/1000000000) + Double(1.0/30.0) - Double(end/1000000000)
        if (time > 0) {
            perform(#selector(startTimer), with: nil, afterDelay: time)
        } else {
            startTimer()
        }
    }

}
