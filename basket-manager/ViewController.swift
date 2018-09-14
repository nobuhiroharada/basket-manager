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
        
        scoreATextField.delegate = self
        scoreBTextField.delegate = self
        
        let tapScoreA = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapScoreLabel))
        scoreALabel.isUserInteractionEnabled = true
        scoreALabel.addGestureRecognizer(tapScoreA)
        
        let tapScoreB = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapScoreLabel))
        scoreBLabel.isUserInteractionEnabled = true
        scoreBLabel.addGestureRecognizer(tapScoreB)
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
    
    @objc func tapScoreLabel(_ sender: UITapGestureRecognizer) {
        if let tappedScoreLabel = sender.view as? UILabel {
            if tappedScoreLabel.tag == 10 {
                openScoreDialog(target: scoreALabel)
            }
            if tappedScoreLabel.tag == 11 {
                openScoreDialog(target: scoreBLabel)
            }
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
    
    // MARK: - スコアダイアログ表示
    func openScoreDialog(target targetLabel:UILabel) {
        let alert = UIAlertController(title: "スコア変更", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    targetLabel.text = textField.text
                }
            }
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = String(0)
            textField.text = targetLabel.text
            textField.keyboardType = UIKeyboardType.numberPad
        })
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
