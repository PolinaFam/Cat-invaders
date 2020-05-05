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
    var spaceShipShootCd = 20
    var spaceShipBullets = [UIImageView]()
    
    var catEnemies = [[CatEnemy]]()
    
    @IBOutlet weak var spaceShip: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawSpaceShip()
        drawCatEnemies()
        updateScoreLabel()
        startTimer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: view)
            
            if(location.x < view.frame.size.width/2) {
                moveShipToLeft(xCoordinates: location.x)
            } else {
                moveShipToRight(xCoordinates: location.x)
            }
        }
    }
    
    func moveShipToLeft(xCoordinates: CGFloat) {
        if (spaceShip.center.x > spaceShip.frame.width/2) {
            spaceShip.center.x -= 15
        }
    }
    
    func moveShipToRight(xCoordinates: CGFloat) {
        if (spaceShip.center.x < UIScreen.main.bounds.width - spaceShip.frame.width/2) {
            spaceShip.center.x += 15
        }
    }
    
    @objc func startTimer() {
        let start = mach_absolute_time()
        
        fireBullet()
        doMove()
        
        let end = mach_absolute_time()
        let time = Double(start/1000000000) + Double(1.0/60.0) - Double(end/1000000000)
        if (time > 0) {
            perform(#selector(startTimer), with: nil, afterDelay: time)
        } else {
            startTimer()
        }
    }
    
    func updateScoreLabel() {
        scoreLabel.text = String(score)
    }
    
    func fireBullet() {
        spaceShipShootCd += 1
        
        if spaceShipShootCd >= 20 {
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
    
    func doMove() {
        moveSpaceShipBullets()
    }
    
    func moveSpaceShipBullets() {
        for (number, item) in spaceShipBullets.enumerated() {
            item.frame.origin.y -= 10
            if item.frame.origin.y < -item.frame.height {
                spaceShipBullets[number].removeFromSuperview()
                spaceShipBullets.remove(at: number)
            }
        }
    }
    
    func drawSpaceShip() {
        spaceShip.frame = CGRect(x: view.frame.width * 0.35,
                                 y: view.frame.height * 0.8,
                                 width: view.frame.width * 0.3,
                                 height: view.frame.width * 0.3)
    }
    
    func drawCatEnemies() {
        for i in 0...3 {
            var catEnemiesX = [CatEnemy]()
            for j in 0...2 {
                let catEnemyFrame = CGRect(x:view.frame.width * 0.20 * CGFloat(i) + view.frame.width * 0.1,
                                           y:view.frame.width * 0.20 * CGFloat(j + 1),
                                           width: view.frame.width * 0.20,
                                           height: view.frame.width * 0.20)
                let newCatEnemy = CatEnemy(frame: catEnemyFrame)
                newCatEnemy.image = #imageLiteral(resourceName: "cat-enemy")
                view.addSubview(newCatEnemy)
                catEnemiesX.append(newCatEnemy)
            }
            catEnemies.append(catEnemiesX)
        }
    }

}
