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
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = String(score)
    }

}