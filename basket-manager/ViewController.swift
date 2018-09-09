//
//  ViewController.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/10.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // スコアA
    @IBOutlet weak var scoreATextField: UITextField!
    @IBOutlet weak var scoreALabel: UILabel!
    @IBOutlet weak var scoreAMinusBtn: UIButton!
    @IBOutlet weak var scoreAPlusBtn: UIButton!
    var scoreA: Int = 0
    
    // スコアB
    @IBOutlet weak var scoreBTextField: UITextField!
    @IBOutlet weak var scoreBLabel: UILabel!
    @IBOutlet weak var scoreBMinusBtn: UIButton!
    @IBOutlet weak var scoreBPlusBtn: UIButton!
    var scoreB: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreATextField.text = "Team A"
        scoreBTextField.text = "Team B"
        
        
    }
    
    // MARK: - チームAスコア Actions
    @IBAction func scoreAMinusBtn(_ sender: UIButton) {
        if scoreA > 0 {
            scoreA -= 1
            scoreALabel.text = String(scoreA)
        }
    }
    
    @IBAction func scoreAPlusBtn(_ sender: UIButton) {
        if scoreA < 1000 {
            scoreA += 1
            scoreALabel.text = String(scoreA)
        }
    }
    
    
    
    // MARK: - チームBスコア Actions
    @IBAction func scoreBMinusBtn(_ sender: UIButton) {
        if scoreB > 0 {
            scoreB -= 1
            scoreBLabel.text = String(scoreB)
        }
    }
    
    @IBAction func scoreBPlusBtn(_ sender: UIButton) {
        if scoreB < 1000 {
            scoreB += 1
            scoreBLabel.text = String(scoreB)
        }
    }
}

