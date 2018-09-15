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
    
    // ゲームタイマー
    var gameTimer: Timer!
    var startGameTime = Date()
    var gameSeconds = 0
    
    @IBOutlet weak var gameMinLabel: UILabel!
    @IBOutlet weak var gameSecLabel: UILabel!

    @IBOutlet weak var gameTimerControlBtn: UIButton!
    @IBOutlet weak var gameResetBtn: UIButton!
    
    var gameTimerStatus: GameTimerStatus = .START
    
    enum GameTimerStatus: String {
        case START
        case STOP
        case RESUME
    }
    
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
        
        gameTimerControlBtn.setTitle("Start", for: .normal)
        gameMinLabel.text = "10"
        gameSecLabel.text = "00"
        gameSeconds = Int(gameMinLabel.text!)!*60
        gameSeconds += Int(gameSecLabel.text!)!
        
        let tapGameMin = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGameMinLabel))
        gameMinLabel.isUserInteractionEnabled = true
        gameMinLabel.addGestureRecognizer(tapGameMin)
        
        let tapGameSec = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGameSecLabel))
        gameSecLabel.isUserInteractionEnabled = true
        gameSecLabel.addGestureRecognizer(tapGameSec)
        
        gameResetBtn.isEnabled = false
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
    
    // ゲームタイムコントローラー
    @IBAction func tapGameTimeControlBtn(_ sender: UIButton) {
        
        switch gameTimerStatus {
            case .START:
                runGameTimer()
                gameTimerControlBtn.setTitle("Stop", for: .normal)
                gameTimerStatus = .STOP
                gameResetBtn.isEnabled = true
            
            case .STOP:
                gameTimer.invalidate()
                gameTimerControlBtn.setTitle("Resume", for: .normal)
                gameTimerStatus = .RESUME
            
            case .RESUME:
                runGameTimer()
                gameTimerControlBtn.setTitle("Stop", for: .normal)
                gameTimerStatus = .STOP
            }
    }
    
    // ゲームタイムリセット
    @IBAction func tapResetGameBtn(_ sender: UIButton) {
        gameTimer.invalidate()
        gameSeconds = 600
        setGameTime()
        gameTimerControlBtn.setTitle("Start", for: .normal)
        gameTimerStatus = .START
        gameResetBtn.isEnabled = false
    }
    
    func runGameTimer(){
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.gameTimerCount),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func gameTimerCount() {
        if gameSeconds < 1 {
            gameTimer.invalidate()
            // DO SOMETHING
            gameSecLabel.text = String(gameSeconds)
        } else {
            gameSeconds -= 1
            setGameTime()
        }
    }
    
    func setGameTime() {
        let min = gameSeconds/60
        let sec = gameSeconds%60
        gameMinLabel.text = String(format: "%02d", min)
        gameSecLabel.text = String(format: "%02d", sec)
    }
    
    // MARK: - ゲーム分ダイアログ表示
    @objc func tapGameMinLabel() {
        let alert = UIAlertController(title: "ゲーム分変更", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.gameMinLabel.text = textField.text
                }
            }
            
            // TODO 0分の場合の if let
            let min = Int(self.gameMinLabel.text!)
            let sec = Int(self.gameSecLabel.text!)
            self.gameSeconds = min!*60 + sec!
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "00"
            textField.text = self.gameMinLabel.text
            textField.keyboardType = UIKeyboardType.numberPad
        })
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ゲーム秒ダイアログ表示
    @objc func tapGameSecLabel() {
        let alert = UIAlertController(title: "ゲーム秒変更", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.gameSecLabel.text = textField.text
                }
            }
            
            // TODO 0分の場合の if let
            let min = Int(self.gameMinLabel.text!)
            let sec = Int(self.gameSecLabel.text!)
            self.gameSeconds = min!*60 + sec!
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "00"
            textField.text = self.gameSecLabel.text
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
