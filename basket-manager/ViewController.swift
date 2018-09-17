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
    var scoreA: Int = 0
    @IBOutlet weak var scoreATextField: UITextField!
    @IBOutlet weak var scoreALabel: UILabel!
    @IBOutlet weak var scoreAMinusBtn: UIButton!
    @IBOutlet weak var scoreAPlusBtn: UIButton!
    
    // スコアB
    var scoreB: Int = 0
    @IBOutlet weak var scoreBTextField: UITextField!
    @IBOutlet weak var scoreBLabel: UILabel!
    @IBOutlet weak var scoreBMinusBtn: UIButton!
    @IBOutlet weak var scoreBPlusBtn: UIButton!
    
    // ゲームタイマー
    var gameTimer: Timer!
    var startGameTime = Date()
    var gameSeconds = 600
    var oldGameSeconds = 600
    var gameTimeMinArray: [String] = []
    var gameTimeSecArray: [String] = []
    var gameTimePicker = UIPickerView()
    var gameTimerStatus: GameTimerStatus = .START
    enum GameTimerStatus: String {
        case START
        case STOP
        case RESUME
    }
    @IBOutlet weak var gameMinLabel: UILabel!
    @IBOutlet weak var gameSecLabel: UILabel!
    @IBOutlet weak var gameTimerControlBtn: UIButton!
    @IBOutlet weak var gameResetBtn: UIButton!
    
    // 24秒
    var timer24: Timer!
    var start24Time = Date()
    var seconds24: Int = 24
    var timer24Status: Timer24Status = .START
    enum Timer24Status: String {
        case START
        case STOP
        case RESUME
    }
    @IBOutlet weak var display24Label: UILabel!
    @IBOutlet weak var control24Btn: UIButton!
    @IBOutlet weak var reset24Btn: UIButton!
    @IBOutlet weak var set24Btn: UIButton!
    @IBOutlet weak var set14Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...20 { //分設定(ゲームタイムピッカー用)
            gameTimeMinArray.append(String(i))
        }
        
        for i in 0..<60 { //秒設定(ゲームタイムピッカー用)
            gameTimeSecArray.append(String(i))
        }
        
        setScoreInitProperty()
        setGameTimeInitProperty()
        set24TimeInitProperty()
        
    }
    
    // MARK: - スコア
    func setScoreInitProperty() {
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
    
    // チームAスコア
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
    
    // チームBスコア
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
    
    // スコアダイアログ表示
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
    
    // MARK: - ゲームタイム
    func setGameTimeInitProperty() {
//        gameMinLabel.isHidden = true
//        gameSecLabel.isHidden = true
        toggleIsHiddenGameLabels()
        gameTimerControlBtn.setTitle("Start", for: .normal)
        gameMinLabel.text = "10"
        gameSecLabel.text = "00"
        gameSeconds = Int(gameMinLabel.text!)!*60
        gameSeconds += Int(gameSecLabel.text!)!
        
        gameResetBtn.isEnabled = false
        
        setGameTimePicker()
    }
    
    // ゲームタイムコントロールボタン押下
    @IBAction func tapGameTimeControlBtn(_ sender: UIButton) {
        
        switch gameTimerStatus {
            case .START:
                runGameTimer()
                gameTimerControlBtn.setTitle("Stop", for: .normal)
                gameTimerStatus = .STOP
                toggleIsHiddenGameLabels()
                gameTimePicker.isHidden = !gameTimePicker.isHidden
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
    
    // ゲームタイムリセットボタン押下
    @IBAction func tapResetGameBtn(_ sender: UIButton) {
        gameTimer.invalidate()
        gameSeconds = oldGameSeconds
        showGameTime()
        gameTimerControlBtn.setTitle("Start", for: .normal)
        gameTimerStatus = .START
        toggleIsHiddenGameLabels()
        gameTimePicker.isHidden = !gameTimePicker.isHidden
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
            showGameTime()
        }
    }
    
    func showGameTime() {
        let min = gameSeconds/60
        let sec = gameSeconds%60
        gameMinLabel.text = String(format: "%02d", min)
        gameSecLabel.text = String(format: "%02d", sec)
    }
    
    func setGameTimePicker() {
        gameTimePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        gameTimePicker.delegate = self
        gameTimePicker.dataSource = self
        gameTimePicker.center = self.view.center
        gameTimePicker.selectRow(10, inComponent: 0, animated: true)
        gameTimePicker.selectRow(0, inComponent: 1, animated: true)
        
        let minLabel = UILabel()
        minLabel.text = "分"
        minLabel.sizeToFit()
        minLabel.frame = CGRect(x: gameTimePicker.bounds.width*0.375 - minLabel.bounds.width/2,
                                y: gameTimePicker.bounds.height/2 - (minLabel.bounds.height/2),
                                width: minLabel.bounds.width,
                                height: minLabel.bounds.height)
        gameTimePicker.addSubview(minLabel)
        
        let secLabel = UILabel()
        secLabel.text = "秒"
        secLabel.sizeToFit()
        secLabel.frame = CGRect(x: gameTimePicker.bounds.width*0.875 - secLabel.bounds.width/2,
                                y: gameTimePicker.bounds.height/2 - (secLabel.bounds.height/2),
                                width: secLabel.bounds.width,
                                height: secLabel.bounds.height)
        gameTimePicker.addSubview(secLabel)
        
        self.view.addSubview(gameTimePicker)
    }
    
    func toggleIsHiddenGameLabels() {
        gameMinLabel.isHidden = !gameMinLabel.isHidden
        gameSecLabel.isHidden = !gameSecLabel.isHidden
    }
    
    // MARK: - 24秒
    func set24TimeInitProperty() {
        display24Label.text = String(seconds24)
        control24Btn.setTitle("Start", for: .normal)
        reset24Btn.setTitle("Reset", for: .normal)
        set24Btn.setTitle("24", for: .normal)
        set14Btn.setTitle("14", for: .normal)
    }
    
    // 24秒コントロールボタンタップ
    @IBAction func tap24ControlBtn(_ sender: UIButton) {
        
        switch timer24Status {
        case .START:
            run24Timer()
            control24Btn.setTitle("Stop", for: .normal)
            timer24Status = .STOP
            reset24Btn.isEnabled = true
            
        case .STOP:
            timer24.invalidate()
            control24Btn.setTitle("Resume", for: .normal)
            timer24Status = .RESUME
            
        case .RESUME:
            run24Timer()
            control24Btn.setTitle("Stop", for: .normal)
            timer24Status = .STOP
        }
    }
    
    func run24Timer(){
        timer24 = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.timer24Count),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func timer24Count() {
        if seconds24 < 1 {
            timer24.invalidate()
            // DO SOMETHING
            display24Label.text = String(seconds24)
        } else {
            seconds24 -= 1
            display24Label.text = String(seconds24)
        }
    }
    
    // 24秒リセットボタンタップ
    @IBAction func tap24ResetBtn(_ sender: UIButton) {
        timer24.invalidate()
        seconds24 = 24
        display24Label.text = String(seconds24)
        control24Btn.setTitle("Start", for: .normal)
        timer24Status = .START
        reset24Btn.isEnabled = false
    }
    
    // 24秒セットボタンタップ
    @IBAction func tap24SetBtn(_ sender: UIButton) {
        seconds24 = 25
    }
    
    // 14秒セットボタンタップ
    @IBAction func tap14SetBtn(_ sender: UIButton) {
        seconds24 = 15
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return gameTimeMinArray.count
        }
        return gameTimeSecArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return gameTimeMinArray[row]
        }
        return gameTimeSecArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            gameMinLabel.text = gameTimeMinArray[row]
            setGameSeconds()

        } else if component == 1 {
            gameSecLabel.text = gameTimeSecArray[row]
            setGameSeconds()
        }
    }
    
    func setGameSeconds() {
        let min = Int(self.gameMinLabel.text!)
        let sec = Int(self.gameSecLabel.text!)
        self.gameSeconds = min!*60 + sec!
        self.oldGameSeconds = gameSeconds
    }
}
