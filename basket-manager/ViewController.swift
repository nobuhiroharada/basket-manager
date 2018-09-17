//
//  ViewController.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/10.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let BASE_COLOR: CGColor = UIColor.darkText.cgColor
    let BASE_DIGIT_RECT: CGRect = CGRect(x: 0, y: 0, width: 90, height: 90)
    let BASE_BUTTON_RECT: CGRect = CGRect(x: 0, y: 0, width: 60, height: 60)
    let SMALL_BUTTON_RECT: CGRect = CGRect(x: 0, y: 0, width: 30, height: 30)
    let BASE_FONT_SIZE: UIFont = UIFont.systemFont(ofSize: 13)
    
    // スコアA
    var scoreA: Int = 0
    @IBOutlet weak var teamALabel: UILabel!
    @IBOutlet weak var scoreALabel: UILabel!
    @IBOutlet weak var scoreAMinusBtn: UIButton!
    @IBOutlet weak var scoreAPlusBtn: UIButton!
    
    // スコアB
    var scoreB: Int = 0
    @IBOutlet weak var teamBLabel: UILabel!
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
    @IBOutlet weak var gameColonLabel: UILabel!
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

        teamALabel.text = "チーム A"
        teamALabel.textAlignment = .center
        teamALabel.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        teamALabel.center = CGPoint(x: self.view.frame.width*(1/4),
                                         y: self.view.frame.height*(5/7)-teamALabel.frame.height*(1/2))
        teamALabel.font = BASE_FONT_SIZE
        
        let tapTeamA = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapTeamALabel))
        teamALabel.isUserInteractionEnabled = true
        teamALabel.addGestureRecognizer(tapTeamA)
        
        teamBLabel.text = "チーム B"
        teamBLabel.textAlignment = .center
        teamBLabel.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        teamBLabel.center = CGPoint(x: self.view.frame.width*(3/4),
                                         y: self.view.frame.height*(5/7)-teamBLabel.frame.height*(1/2))
        teamBLabel.font = BASE_FONT_SIZE
        
        let tapTeamB = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapTeamBLabel))
        teamBLabel.isUserInteractionEnabled = true
        teamBLabel.addGestureRecognizer(tapTeamB)
        
        scoreALabel.text = "00"
        scoreALabel.textAlignment = .center
        scoreALabel.bounds = CGRect(x: 0, y: 0, width: 140, height: 90)
        scoreALabel.center = CGPoint(x: self.view.frame.width*(1/4),
                                      y: self.view.frame.height*(6/7)-scoreALabel.frame.height*(3/4))
        scoreALabel.font = UIFont.boldSystemFont(ofSize: 70)
        
        let tapScoreA = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapScoreALabel))
        scoreALabel.isUserInteractionEnabled = true
        scoreALabel.addGestureRecognizer(tapScoreA)
        
        scoreBLabel.text = "00"
        scoreBLabel.textAlignment = .center
        scoreBLabel.bounds = CGRect(x: 0, y: 0, width: 140, height: 90)
        scoreBLabel.center = CGPoint(x: self.view.frame.width*(3/4),
                                     y: self.view.frame.height*(6/7)-scoreBLabel.frame.height*(3/4))
        scoreBLabel.font = UIFont.boldSystemFont(ofSize: 70)
        
        let tapScoreB = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapScoreBLabel))
        scoreBLabel.isUserInteractionEnabled = true
        scoreBLabel.addGestureRecognizer(tapScoreB)
        
        scoreAMinusBtn.setTitle("-", for: .normal)
        scoreAMinusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        scoreAMinusBtn.bounds = SMALL_BUTTON_RECT
        scoreAMinusBtn.center = CGPoint(x: self.view.frame.width*(1/8), y: self.view.frame.height*(6/7))
        scoreAMinusBtn.layer.borderColor = BASE_COLOR
        scoreAMinusBtn.layer.borderWidth = 1
        scoreAMinusBtn.layer.cornerRadius = scoreAMinusBtn.frame.width/2
        
        scoreAPlusBtn.setTitle("+", for: .normal)
        scoreAPlusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        scoreAPlusBtn.bounds = SMALL_BUTTON_RECT
        scoreAPlusBtn.center = CGPoint(x: self.view.frame.width*(3/8), y: self.view.frame.height*(6/7))
        scoreAPlusBtn.layer.borderColor = BASE_COLOR
        scoreAPlusBtn.layer.borderWidth = 1
        scoreAPlusBtn.layer.cornerRadius = scoreAPlusBtn.frame.width/2
        
        scoreBMinusBtn.setTitle("-", for: .normal)
        scoreBMinusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        scoreBMinusBtn.bounds = SMALL_BUTTON_RECT
        scoreBMinusBtn.center = CGPoint(x: self.view.frame.width*(5/8), y: self.view.frame.height*(6/7))
        scoreBMinusBtn.layer.borderColor = BASE_COLOR
        scoreBMinusBtn.layer.borderWidth = 1
        scoreBMinusBtn.layer.cornerRadius = scoreBMinusBtn.frame.width/2
        
        scoreBPlusBtn.setTitle("+", for: .normal)
        scoreBPlusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        scoreBPlusBtn.bounds = SMALL_BUTTON_RECT
        scoreBPlusBtn.center = CGPoint(x: self.view.frame.width*(7/8), y: self.view.frame.height*(6/7))
        scoreBPlusBtn.layer.borderColor = BASE_COLOR
        scoreBPlusBtn.layer.borderWidth = 1
        scoreBPlusBtn.layer.cornerRadius = scoreBPlusBtn.frame.width/2
    }
    
    // チームAスコア
    @IBAction func tapScoreAMinusBtn(_ sender: UIButton) {
        if scoreA > 0 {
            scoreA -= 1
            scoreALabel.text = String(scoreA)
        }
    }
    
    @IBAction func tapScoreAPlusBtn(_ sender: UIButton) {
        if scoreA < 1000 {
            scoreA += 1
            scoreALabel.text = String(scoreA)
        }
    }
    
    @objc func tapTeamALabel(_ sender: UITapGestureRecognizer) {
        openTeamADialog()
    }
    
    @objc func tapTeamBLabel(_ sender: UITapGestureRecognizer) {
        openTeamBDialog()
    }
    
    @objc func tapScoreALabel(_ sender: UITapGestureRecognizer) {
        openScoreADialog()
    }
    
    @objc func tapScoreBLabel(_ sender: UITapGestureRecognizer) {
        openScoreBDialog()
    }
    
    // チームBスコア
    @IBAction func tapScoreBMinusBtn(_ sender: UIButton) {
        if scoreB > 0 {
            scoreB -= 1
            scoreBLabel.text = String(scoreB)
        }
    }
    
    @IBAction func tapScoreBPlusBtn(_ sender: UIButton) {
        if scoreB < 1000 {
            scoreB += 1
            scoreBLabel.text = String(scoreB)
        }
    }
    
    // チームAダイアログ表示
    func openTeamADialog() {
        let alert = UIAlertController(title: "チームA名前修正", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.teamALabel.text = textField.text
                }
            }
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "チームA"
            textField.text = self.teamALabel.text
        })
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // チームBダイアログ表示
    func openTeamBDialog() {
        let alert = UIAlertController(title: "チームB名前修正", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.teamBLabel.text = textField.text
                }
            }
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "チームB"
            textField.text = self.teamBLabel.text
        })
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // スコアAダイアログ表示
    func openScoreADialog() {
        let alert = UIAlertController(title: "チームAスコア修正", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.scoreALabel.text = textField.text
                    self.scoreA = Int(textField.text!)!
                }
            }
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = String(0)
            textField.text = self.scoreALabel.text
            textField.keyboardType = UIKeyboardType.numberPad
        })
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // スコアBダイアログ表示
    func openScoreBDialog() {
        let alert = UIAlertController(title: "チームBスコア修正", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.scoreBLabel.text = textField.text
                    self.scoreB = Int(textField.text!)!
                }
            }
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = String(0)
            textField.text = self.scoreBLabel.text
            textField.keyboardType = UIKeyboardType.numberPad
        })
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ゲームタイム
    func setGameTimeInitProperty() {
        gameMinLabel.text = "10"
        gameMinLabel.textAlignment = .center
        gameMinLabel.bounds = BASE_DIGIT_RECT
        gameMinLabel.center = CGPoint(x: self.view.frame.width*(1/3),
                                      y: self.view.frame.height*(1/2)-gameMinLabel.bounds.height*(1/2))
        gameMinLabel.font = UIFont.boldSystemFont(ofSize: 70)
        
        gameColonLabel.text = ":"
        gameColonLabel.textAlignment = .center
        gameColonLabel.bounds = CGRect(x: 0, y: 0, width: 30, height: 100)
        gameColonLabel.center = CGPoint(x: self.view.frame.width*(1/2),
                                        y: self.view.frame.height*(1/2)-gameColonLabel.bounds.height*(1/2))
        gameColonLabel.font = UIFont.boldSystemFont(ofSize: 70)
        
        gameSecLabel.text = "00"
        gameSecLabel.textAlignment = .center
        gameSecLabel.bounds = BASE_DIGIT_RECT
        gameSecLabel.center = CGPoint(x: self.view.frame.width*(2/3),
                                      y: self.view.frame.height*(1/2)-gameSecLabel.bounds.height*(1/2))
        gameSecLabel.font = UIFont.boldSystemFont(ofSize: 70)
        
        toggleIsHiddenGameLabels()
        
        gameTimerControlBtn.setTitle("開始", for: .normal)
        gameTimerControlBtn.titleLabel?.font = BASE_FONT_SIZE
        gameTimerControlBtn.bounds = BASE_BUTTON_RECT
        gameTimerControlBtn.center = CGPoint(x: self.view.frame.width*(1/3), y: self.view.frame.height*(4/7))
        gameTimerControlBtn.layer.borderColor = BASE_COLOR
        gameTimerControlBtn.layer.borderWidth = 1
        gameTimerControlBtn.layer.cornerRadius = gameTimerControlBtn.frame.width/2
        
        gameResetBtn.isEnabled = false
        gameResetBtn.setTitle("リセット", for: .normal)
        gameResetBtn.titleLabel?.font = BASE_FONT_SIZE
        gameResetBtn.bounds = BASE_BUTTON_RECT
        gameResetBtn.center = CGPoint(x: self.view.frame.width*(2/3), y: self.view.frame.height*(4/7))
        gameResetBtn.layer.borderColor = BASE_COLOR
        gameResetBtn.layer.borderWidth = 1
        gameResetBtn.layer.cornerRadius = gameResetBtn.frame.width/2
        
        gameSeconds = Int(gameMinLabel.text!)!*60
        gameSeconds += Int(gameSecLabel.text!)!
        
        setGameTimePicker()
    }
    
    // ゲームタイムコントロールボタン押下
    @IBAction func tapGameTimeControlBtn(_ sender: UIButton) {
        
        switch gameTimerStatus {
            case .START:
                runGameTimer()
                gameTimerControlBtn.setTitle("停止", for: .normal)
                gameTimerStatus = .STOP
                toggleIsHiddenGameLabels()
                gameTimePicker.isHidden = !gameTimePicker.isHidden
                gameResetBtn.isEnabled = true
            
            case .STOP:
                gameTimer.invalidate()
                gameTimerControlBtn.setTitle("再開", for: .normal)
                gameTimerStatus = .RESUME
            
            case .RESUME:
                runGameTimer()
                gameTimerControlBtn.setTitle("停止", for: .normal)
                gameTimerStatus = .STOP
        }
    }
    
    // ゲームタイムリセットボタン押下
    @IBAction func tapResetGameBtn(_ sender: UIButton) {
        gameTimer.invalidate()
        gameSeconds = oldGameSeconds
        showGameTime()
        gameTimerControlBtn.setTitle("開始", for: .normal)
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
        gameTimePicker.center = CGPoint(x: self.view.frame.width*(1/2),
                                        y: self.view.frame.height*(1/2)-gameTimePicker.bounds.height*(1/2))
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
        gameColonLabel.isHidden = !gameColonLabel.isHidden
        gameSecLabel.isHidden = !gameSecLabel.isHidden
    }
    
    // MARK: - 24秒
    func set24TimeInitProperty() {
        display24Label.text = String(seconds24)
        display24Label.bounds = BASE_DIGIT_RECT
        display24Label.center = CGPoint(x: self.view.frame.width*(1/2), y: self.view.frame.height*(1/7))
        display24Label.font = UIFont.boldSystemFont(ofSize: 70)
        
        control24Btn.setTitle("開始", for: .normal)
        control24Btn.titleLabel?.font = BASE_FONT_SIZE
        control24Btn.bounds = BASE_BUTTON_RECT
        control24Btn.center = CGPoint(x: self.view.frame.width*(1/3), y: self.view.frame.height*(2/7))
        control24Btn.layer.borderColor = BASE_COLOR
        control24Btn.layer.borderWidth = 1
        control24Btn.layer.cornerRadius = control24Btn.frame.width/2
        
        reset24Btn.setTitle("リセット", for: .normal)
        reset24Btn.titleLabel?.font = BASE_FONT_SIZE
        reset24Btn.bounds = BASE_BUTTON_RECT
        reset24Btn.center = CGPoint(x: self.view.frame.width*(2/3), y: self.view.frame.height*(2/7))
        reset24Btn.layer.borderColor = BASE_COLOR
        reset24Btn.layer.borderWidth = 1
        reset24Btn.layer.cornerRadius = reset24Btn.frame.width/2
        
        set24Btn.setTitle("24", for: .normal)
        set24Btn.titleLabel?.font = BASE_FONT_SIZE
        set24Btn.frame = CGRect(x: self.view.frame.width*(1/2) + display24Label.frame.width,
                                y: self.view.frame.height*(1/7) - set24Btn.frame.height,
                                width: 30, height: 30)
        set24Btn.layer.borderColor = BASE_COLOR
        set24Btn.layer.borderWidth = 1
        set24Btn.layer.cornerRadius = set24Btn.frame.width/2
        
        set14Btn.setTitle("14", for: .normal)
        set14Btn.titleLabel?.font = BASE_FONT_SIZE
        set14Btn.frame = CGRect(x: self.view.frame.width*(1/2) + display24Label.frame.width,
                                y: self.view.frame.height*(1/7),
                                width: 30, height: 30)
        set14Btn.layer.borderColor = BASE_COLOR
        set14Btn.layer.borderWidth = 1
        set14Btn.layer.cornerRadius = set24Btn.frame.width/2
    }
    
    // 24秒コントロールボタンタップ
    @IBAction func tap24ControlBtn(_ sender: UIButton) {
        
        switch timer24Status {
        case .START:
            run24Timer()
            control24Btn.setTitle("停止", for: .normal)
            timer24Status = .STOP
            reset24Btn.isEnabled = true
            
        case .STOP:
            timer24.invalidate()
            control24Btn.setTitle("再開", for: .normal)
            timer24Status = .RESUME
            
        case .RESUME:
            run24Timer()
            control24Btn.setTitle("停止", for: .normal)
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
        switch timer24Status {
        case .START:
            return
        case .STOP:
            seconds24 = 24
            display24Label.text = String(seconds24)
        case .RESUME:
            timer24.invalidate()
            seconds24 = 24
            display24Label.text = String(seconds24)
            control24Btn.setTitle("開始", for: .normal)
            timer24Status = .START
            reset24Btn.isEnabled = false
        }
    }
    
    // 24秒セットボタンタップ
    @IBAction func tap24SetBtn(_ sender: UIButton) {
        seconds24 = 24
        display24Label.text = "24"
    }
    
    // 14秒セットボタンタップ
    @IBAction func tap14SetBtn(_ sender: UIButton) {
        seconds24 = 14
        display24Label.text = "14"
    }
    
    // MARK: - ツールバーアクションボタンタップ
    @IBAction func tapShareBtn(_ sender: UIBarButtonItem) {
        
        let teamA = (teamALabel.text != nil) ? teamALabel.text! : "チームA"
        let teamB = (teamBLabel.text != nil) ? teamBLabel.text! : "チームB"
        let scoreA = (scoreALabel.text != nil) ? scoreALabel.text! : "00"
        let scoreB = (scoreBLabel.text != nil) ? scoreBLabel.text! : "00"
        
        let shareText = "試合結果: \(teamA) vs \(teamB) は \(scoreA) - \(scoreB) でした。"
        
        let activityItems = [shareText]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
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
