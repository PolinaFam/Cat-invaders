//
//  LossViewController.swift
//  cat invaders
//
//  Created by student on 05/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit

class LossViewController: UIViewController {
 
    var score: Int = 0
    var highScore: Int = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = String(score)
        highScoreLabel.text = String(highScore)
    }

}
