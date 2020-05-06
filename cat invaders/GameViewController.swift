//
//  GameViewController.swift
//  cat invaders
//
//  Created by student on 04/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var liveCatEnemies = 12
    var isGameOver = false
    
    var game = Game()
    
    var moveDirection2N = 1
    var moveDirectionN = -1
    var moveCatEnemyCd = 5
    
    var spaceShipShootCd = 20
    var spaceShipBullets = [UIImageView]()
    
    var catEnemies = [[CatEnemy]]()
    var catEnemyShootCd = 30
    var catEnemyBullets = [UIImageView]()
    
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
            spaceShip.center.x -= spaceShip.frame.width * 0.25
        }
    }
    
    func moveShipToRight(xCoordinates: CGFloat) {
        if (spaceShip.center.x < UIScreen.main.bounds.width - spaceShip.frame.width/2) {
            spaceShip.center.x += spaceShip.frame.width * 0.25
        }
    }
    
    func drawSpaceShip() {
        spaceShip.frame = CGRect(x: view.frame.width * 0.35,
                                 y: view.frame.height - view.frame.width * 0.3 - CGFloat(20),
                                 width: view.frame.width * 0.3,
                                 height: view.frame.width * 0.3)
    }
    
    func drawCatEnemies() {
        for i in 0...3 {
            var catEnemiesX = [CatEnemy]()
            for j in 0...2 {
                let catEnemyFrame = CGRect(x:view.frame.width * 0.20 * CGFloat(i) + view.frame.width * 0.1,
                                           y:view.frame.width * 0.20 * CGFloat(j) + scoreLabel.frame.origin.y + scoreLabel.frame.height + 10,
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
    
    func updateScoreLabel() {
        scoreLabel.text = String(game.score)
    }
    
    @objc func startTimer() {
        if !isGameOver {
            let start = mach_absolute_time()
            
            fireSpaceShipBullet()
            fireCatEnemyBullet()
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
    
    func fireSpaceShipBullet() {
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
    
    func fireCatEnemyBullet() {
        catEnemyShootCd += 1
        
        if (catEnemyShootCd >= 30) {
            var catEnemy = catEnemies[Int.random(in: 0...3)][Int.random(in: 0...2)]
            while (catEnemy.isHidden == true) {
                catEnemy = catEnemies[Int.random(in: 0...3)][Int.random(in: 0...2)]
            }
            let bulletFrame = CGRect (x: catEnemy.frame.origin.x + catEnemy.frame.width * 0.4,
                                      y: catEnemy.frame.origin.y + catEnemy.frame.height,
                                      width: catEnemy.frame.width * 0.2,
                                      height: catEnemy.frame.height * 0.3)
            let newBullet = UIImageView(frame: bulletFrame)
            newBullet.image = #imageLiteral(resourceName: "enemyBullet")
            view.addSubview(newBullet)
            catEnemyBullets.append(newBullet)
            catEnemyShootCd = 0
        }
    }
    
    func doMove() {
        moveSpaceShipBullets()
        moveCatEnemyBullets()
        moveCatEnemy()
    }
    
    func moveSpaceShipBullets() {
        for (number, item) in spaceShipBullets.enumerated() {
            item.frame.origin.y -= 10
            if item.frame.origin.y < -item.frame.height {
                spaceShipBullets[number].removeFromSuperview()
                spaceShipBullets.remove(at: number)
            } else {
                for i in 0...3 {
                    for j in 0...2 {
                        if (item.frame.intersects(catEnemies[i][j].frame) && catEnemies[i][j].isHidden == false) {
                            spaceShipBullets[number].removeFromSuperview()
                            spaceShipBullets.remove(at: number)
                            killCatEnemy(cat: catEnemies[i][j])
                            
                            if (liveCatEnemies == 0) {
                                isGameOver = true
                                gameOver(result: "win")
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    func killCatEnemy(cat: CatEnemy) {
        cat.isHidden = true
        game.score += 1
        updateScoreLabel()
        liveCatEnemies -= 1
    }
    
    func moveCatEnemyBullets() {
        for (number, item) in catEnemyBullets.enumerated() {
            item.frame.origin.y += 10
            if item.frame.origin.y > item.frame.height + view.frame.height {
                catEnemyBullets[number].removeFromSuperview()
                catEnemyBullets.remove(at: number)
            } else if item.frame.intersects(spaceShip.frame) {
                catEnemyBullets[number].removeFromSuperview()
                catEnemyBullets.remove(at: number)
                isGameOver = true
                gameOver(result: "loss")
                return
            }
        }
    }
    
    func moveCatEnemy() {
        moveCatEnemyCd += 1
        
        if moveCatEnemyCd >= 5 {
            var toChangeDirection2N = false
            var toChangeDirectionN = false
            for i in 0...3 {
                for j in 0...2 {
                    var catEnemyX: CGFloat
                    
                    if (j % 2 == 0) {
                        catEnemyX = catEnemies[i][j].frame.origin.x + view.frame.width * 0.01 * CGFloat(moveDirection2N)
                        catEnemies[i][j].frame.origin.x += view.frame.width * 0.01 * CGFloat(moveDirection2N)
                        if ((catEnemyX < 0) || (catEnemyX  + catEnemies[i][j].frame.width > view.frame.width)) {
                            toChangeDirection2N = true
                        }
                    } else {
                        catEnemyX = catEnemies[i][j].frame.origin.x + view.frame.width * 0.01 * CGFloat(moveDirectionN)
                        catEnemies[i][j].frame.origin.x += view.frame.width * 0.01 * CGFloat(moveDirectionN)
                        if ((catEnemyX < 0) || (catEnemyX + catEnemies[i][j].frame.width > view.frame.width)) {
                            toChangeDirectionN = true
                        }
                    }
                }
            }
            if toChangeDirection2N {
                moveDirection2N *= -1
            }
            if toChangeDirectionN {
                moveDirectionN *= -1
            }
            moveCatEnemyCd = 0
        }
    }
    
    func gameOver (result: String) {
        if result == "win" {
            game.saveGame()
        }
        performSegue(withIdentifier: result, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loss" {
            let lossViewController = segue.destination as! LossViewController
            lossViewController.score = game.score
        }
        if segue.identifier == "win" {
            let winViewController = segue.destination as! WinViewController
            winViewController.score = game.score
            winViewController.highScore = game.highScore
        }
    }
}
