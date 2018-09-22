//
//  ViewController.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/10.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let BASE_COLOR: CGColor = UIColor.darkText.cgColor
    let BASE_DIGIT_RECT: CGRect = CGRect(x: 0, y: 0, width: 90, height: 90)
    let BASE_BUTTON_RECT: CGRect = CGRect(x: 0, y: 0, width: 60, height: 60)
    let SMALL_BUTTON_RECT: CGRect = CGRect(x: 0, y: 0, width: 30, height: 30)
    let BASE_FONT_SIZE: UIFont = UIFont.systemFont(ofSize: 13)
    
    // MARK: - スコア変数
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
    
    // MARK: - ゲームタイマー変数
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
    @IBOutlet weak var possessionALabel: UILabel!
    @IBOutlet weak var possessionBLabel: UILabel!
    
    // MARK: -  ショットクロック変数
    var shotClockTimer: Timer!
    var shotSeconds: Int = 24
    var shotClockStatus: ShotClockStatus = .START
    enum ShotClockStatus: String {
        case START
        case STOP
        case RESUME
    }
    
    @IBOutlet weak var shotClockLabel: UILabel!
    @IBOutlet weak var shotClockControlBtn: UIButton!
    @IBOutlet weak var shotClockResetBtn: UIButton!
    @IBOutlet weak var sec24Btn: UIButton!
    @IBOutlet weak var sec14Btn: UIButton!
    
    // MARK: - ツールバー ブザーボタン
    @IBOutlet weak var buzzerBtn: UIButton!
    var buzzerAudioPlayer : AVAudioPlayer! = nil
    var isBuzzerRunning: Bool = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...20 { //分設定(ゲームタイムピッカー用)
            gameTimeMinArray.append(String(i))
        }
        
        for i in 0..<60 { //秒設定(ゲームタイムピッカー用)
            gameTimeSecArray.append(String(i))
        }
        
        initScore()
        initGameTime()
        initShotClock()
        initBuzzer()
    }
    
    // MARK: - スコア
    func initScore() {
        
        teamALabel.text = "HOME"
        teamALabel.textAlignment = .center
        teamALabel.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        let teamNameHeight = self.view.frame.height*(5/7)-teamALabel.frame.height*0.5
        
        teamALabel.center = CGPoint(x: self.view.frame.width*(1/4),
                                         y: teamNameHeight)
        teamALabel.font = BASE_FONT_SIZE
        
        let tapTeamA = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapTeamALabel))
        teamALabel.isUserInteractionEnabled = true
        teamALabel.addGestureRecognizer(tapTeamA)
        
        teamBLabel.text = "GUEST"
        teamBLabel.textAlignment = .center
        teamBLabel.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        teamBLabel.center = CGPoint(x: self.view.frame.width*(3/4),
                                         y: teamNameHeight)
        teamBLabel.font = BASE_FONT_SIZE
        
        let tapTeamB = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapTeamBLabel))
        teamBLabel.isUserInteractionEnabled = true
        teamBLabel.addGestureRecognizer(tapTeamB)
        
        
        
        scoreALabel.text = "00"
        scoreALabel.textAlignment = .center
        scoreALabel.bounds = CGRect(x: 0, y: 0, width: 140, height: 90)
        
        let scoreLabelHeight = self.view.frame.height*(6/7)-scoreALabel.frame.height*0.75
        
        scoreALabel.center = CGPoint(x: self.view.frame.width*(1/4),
                                      y: scoreLabelHeight)
        scoreALabel.font = UIFont.boldSystemFont(ofSize: 70)
        
        let tapScoreA = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapScoreALabel))
        scoreALabel.isUserInteractionEnabled = true
        scoreALabel.addGestureRecognizer(tapScoreA)
        
        scoreBLabel.text = "00"
        scoreBLabel.textAlignment = .center
        scoreBLabel.bounds = CGRect(x: 0, y: 0, width: 140, height: 90)
        scoreBLabel.center = CGPoint(x: self.view.frame.width*(3/4),
                                     y: scoreLabelHeight)
        scoreBLabel.font = UIFont.boldSystemFont(ofSize: 70)
        
        let tapScoreB = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapScoreBLabel))
        scoreBLabel.isUserInteractionEnabled = true
        scoreBLabel.addGestureRecognizer(tapScoreB)
        
        let possessionLabelHight = self.view.frame.height*(6/7)-scoreALabel.frame.height*0.75
        
        possessionALabel.text = "←"
        possessionALabel.textAlignment = .center
        possessionALabel.bounds = SMALL_BUTTON_RECT
        possessionALabel.center = CGPoint(x: self.view.frame.width*(1/2)-possessionALabel.frame.width*0.5,
                                     y: possessionLabelHight)
        possessionALabel.font = BASE_FONT_SIZE
        possessionALabel.isHidden = false
        let tapPossessionA = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapPossessionA))
        possessionALabel.isUserInteractionEnabled = true
        possessionALabel.addGestureRecognizer(tapPossessionA)
        
        possessionBLabel.text = "→"
        possessionBLabel.textAlignment = .center
        possessionBLabel.bounds = SMALL_BUTTON_RECT
        possessionBLabel.center = CGPoint(x: self.view.frame.width*(1/2)+possessionBLabel.frame.width*0.5,
                                     y: possessionLabelHight)
        possessionBLabel.font = BASE_FONT_SIZE
        possessionBLabel.isHidden = true
        let tapPossessionB = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapPossessionB))
        possessionBLabel.isUserInteractionEnabled = true
        possessionBLabel.addGestureRecognizer(tapPossessionB)
        
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
//        scoreBMinusBtn.addTarget(self, action: #selector(highlightBorder), for: .touchDown)
//        scoreBMinusBtn.addTarget(self, action: #selector(normalBorder), for: .touchUpInside)
        
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
    
    @objc func tapTeamALabel(_ sender: UITapGestureRecognizer) {
        openTeamNameAEditDialog()
    }
    
    @objc func tapTeamBLabel(_ sender: UITapGestureRecognizer) {
        openTeamNameBEditDialog()
    }
    
    @objc func tapScoreALabel(_ sender: UITapGestureRecognizer) {
        openScoreAEditDialog()
    }
    
    @objc func tapScoreBLabel(_ sender: UITapGestureRecognizer) {
        openScoreBEditDialog()
    }
    
    @objc func tapPossessionA(_ sender: UITapGestureRecognizer) {
        possessionALabel.isHidden = true
        possessionBLabel.isHidden = false
    }
    
    @objc func tapPossessionB(_ sender: UITapGestureRecognizer) {
        possessionALabel.isHidden = false
        possessionBLabel.isHidden = true
    }
    
    // チームA名前編集ダイアログ表示
    func openTeamNameAEditDialog() {
        let alert = UIAlertController(title: "HOME名前修正", message: "", preferredStyle: .alert)
        
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
            textField.placeholder = "HOME"
            textField.text = self.teamALabel.text
        })
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // チームBダイアログ表示
    func openTeamNameBEditDialog() {
        let alert = UIAlertController(title: "GUEST名前修正", message: "", preferredStyle: .alert)
        
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
            textField.placeholder = "GUEST"
            textField.text = self.teamBLabel.text
        })
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // スコアAダイアログ表示
    func openScoreAEditDialog() {
        let alert = UIAlertController(title: "HOMEスコア修正", message: "", preferredStyle: .alert)
        
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
    
    // GUESTダイアログ表示
    func openScoreBEditDialog() {
        let alert = UIAlertController(title: "GUESTスコア修正", message: "", preferredStyle: .alert)
        
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
    func initGameTime() {
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
//        gameTimerControlBtn.addTarget(self, action: #selector(highlightBorder), for: .touchDown)
//        gameTimerControlBtn.addTarget(self, action: #selector(normalBorder), for: .touchUpInside)
        
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
            gameSecLabel.text = "00"
            openGameTimeOverDialog()
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
    
    func openGameTimeOverDialog() {
        let alert = UIAlertController(title: "タイムオーバー", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            self.gameTimerControlBtn.setTitle("開始", for: .normal)
            self.gameSeconds = 600
            self.gameTimerStatus = .START
            self.toggleIsHiddenGameLabels()
            self.setGameTimePicker()
        })
        
        alert.addAction(okAction)
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func toggleIsHiddenGameLabels() {
        gameMinLabel.isHidden = !gameMinLabel.isHidden
        gameColonLabel.isHidden = !gameColonLabel.isHidden
        gameSecLabel.isHidden = !gameSecLabel.isHidden
    }
    
    // MARK: - ショットクロック
    func initShotClock() {
        shotClockLabel.text = String(shotSeconds)
        shotClockLabel.bounds = BASE_DIGIT_RECT
        shotClockLabel.center = CGPoint(x: self.view.frame.width*(1/2), y: self.view.frame.height*(1/7))
        shotClockLabel.font = UIFont.boldSystemFont(ofSize: 70)
        
        shotClockControlBtn.setTitle("開始", for: .normal)
        shotClockControlBtn.titleLabel?.font = BASE_FONT_SIZE
        shotClockControlBtn.bounds = BASE_BUTTON_RECT
        shotClockControlBtn.center = CGPoint(x: self.view.frame.width*(1/3), y: self.view.frame.height*(2/7))
        shotClockControlBtn.layer.borderColor = BASE_COLOR
        shotClockControlBtn.layer.borderWidth = 1
        shotClockControlBtn.layer.cornerRadius = shotClockControlBtn.frame.width/2
        
        shotClockResetBtn.setTitle("リセット", for: .normal)
        shotClockResetBtn.titleLabel?.font = BASE_FONT_SIZE
        shotClockResetBtn.bounds = BASE_BUTTON_RECT
        shotClockResetBtn.center = CGPoint(x: self.view.frame.width*(2/3), y: self.view.frame.height*(2/7))
        shotClockResetBtn.layer.borderColor = BASE_COLOR
        shotClockResetBtn.layer.borderWidth = 1
        shotClockResetBtn.layer.cornerRadius = shotClockResetBtn.frame.width/2
        
        sec24Btn.setTitle("24", for: .normal)
        sec24Btn.titleLabel?.font = BASE_FONT_SIZE
        sec24Btn.frame = CGRect(x: self.view.frame.width*(1/2) + shotClockLabel.frame.width,
                                y: self.view.frame.height*(1/7) - sec24Btn.frame.height,
                                width: 30, height: 30)
        sec24Btn.layer.borderColor = BASE_COLOR
        sec24Btn.layer.borderWidth = 1
        sec24Btn.layer.cornerRadius = sec24Btn.frame.width/2
        
        sec14Btn.setTitle("14", for: .normal)
        sec14Btn.titleLabel?.font = BASE_FONT_SIZE
        sec14Btn.frame = CGRect(x: self.view.frame.width*(1/2) + shotClockLabel.frame.width,
                                y: self.view.frame.height*(1/7),
                                width: 30, height: 30)
        sec14Btn.layer.borderColor = BASE_COLOR
        sec14Btn.layer.borderWidth = 1
        sec14Btn.layer.cornerRadius = sec24Btn.frame.width/2
    }
    
    // ショットクロックコントロールボタンタップ
    @IBAction func tapShotClockControlBtn(_ sender: UIButton) {
        switch shotClockStatus {
        case .START:
            runShotCloclTimer()
            shotClockControlBtn.setTitle("停止", for: .normal)
            shotClockStatus = .STOP
            shotClockResetBtn.isEnabled = true
        
        case .STOP:
            shotClockTimer.invalidate()
            shotClockControlBtn.setTitle("再開", for: .normal)
            shotClockStatus = .RESUME
        
        case .RESUME:
            runShotCloclTimer()
            shotClockControlBtn.setTitle("停止", for: .normal)
            shotClockStatus = .STOP
        }
    }
    
    func runShotCloclTimer(){
        shotClockTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.shotClockCount),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func shotClockCount() {
        if shotSeconds < 1 {
            shotClockTimer.invalidate()
            shotClockLabel.text = String(shotSeconds)
            openShotClockTimeOverDialog()
        } else {
            shotSeconds -= 1
            shotClockLabel.text = String(shotSeconds)
        }
    }
    
    // 24秒リセットボタンタップ
    @IBAction func tapShotClockResetBtn(_ sender: UIButton) {
        switch shotClockStatus {
        case .START:
            return
        case .STOP:
            shotSeconds = 24
            shotClockLabel.text = String(shotSeconds)
        case .RESUME:
            shotClockTimer.invalidate()
            shotSeconds = 24
            shotClockLabel.text = String(shotSeconds)
            shotClockControlBtn.setTitle("開始", for: .normal)
            shotClockStatus = .START
            shotClockResetBtn.isEnabled = false
        }
    }
    
    // 24秒セットボタンタップ
    @IBAction func tapSec24Btn(_ sender: UIButton) {
        shotSeconds = 24
        shotClockLabel.text = "24"
    }
    
    // 14秒セットボタンタップ
    @IBAction func tapSec14Btn(_ sender: UIButton) {
        shotSeconds = 14
        shotClockLabel.text = "14"
    }
    
    func openShotClockTimeOverDialog() {
        
        let alert = UIAlertController(title: "タイムオーバー", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            self.shotClockControlBtn.setTitle("開始", for: .normal)
            self.shotSeconds = 24
            self.shotClockLabel.text = String(self.shotSeconds)
            self.shotClockStatus = .START
        })
        
        alert.addAction(okAction)
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ツールバーブザーボタンタップ
    func initBuzzer() {
        
        buzzerBtn.setTitle("▶", for: .normal)
        buzzerBtn.addTarget(self, action: #selector(buzzerBtnTouchDown), for: .touchDown)
        buzzerBtn.addTarget(self, action: #selector(buzzerBtnTouchUpInside), for: .touchUpInside)
        
        setBuzzerPlayer()
    }
    
    func setBuzzerPlayer() {
        let soundFilePath = Bundle.main.path(forResource: "buzzer", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        
        do {
            buzzerAudioPlayer = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成失敗")
        }
        // バッファに保持していつでも再生できるようにする
        buzzerAudioPlayer.prepareToPlay()
    }
    
    @objc func buzzerBtnTouchDown() {
        if !isBuzzerRunning {
            buzzerAudioPlayer.play()
        }
        isBuzzerRunning = true
    }
    
    @objc func buzzerBtnTouchUpInside() {
        if isBuzzerRunning {
            buzzerAudioPlayer.stop()
            setBuzzerPlayer()
        }
        isBuzzerRunning = false
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
