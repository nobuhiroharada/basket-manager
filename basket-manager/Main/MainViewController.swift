//
//  ViewController.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/10.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    let BASE_COLOR: CGColor = UIColor.darkText.cgColor
    let BASE_DIGIT_RECT: CGRect = CGRect(x: 0, y: 0, width: 110, height: 90)
    
    let limegreen: UIColor = UIColor(red: 173/255.0, green: 255/255.0, blue: 47/255.0, alpha: 1.0)
    let gold: UIColor = UIColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0)
    
    // MARK: - スコア変数
    // スコアA
    var scoreA: Int = 0
    @IBOutlet weak var teamALabel: TeamLabel!
    @IBOutlet weak var scoreALabel: ScoreLabel!
    @IBOutlet weak var scoreAMinusBtn: SmallButton!
    @IBOutlet weak var scoreAPlusBtn: SmallButton!
    
    // スコアB
    var scoreB: Int = 0
    @IBOutlet weak var teamBLabel: TeamLabel!
    @IBOutlet weak var scoreBLabel: ScoreLabel!
    @IBOutlet weak var scoreBMinusBtn: SmallButton!
    @IBOutlet weak var scoreBPlusBtn: SmallButton!
    
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
    @IBOutlet weak var gameTimerControlBtn: ControlButton!
    @IBOutlet weak var gameResetBtn: ResetButton!
    @IBOutlet weak var possessionALabel: PossesLabel!
    @IBOutlet weak var possessionBLabel: PossesLabel!
    
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
    @IBOutlet weak var shotClockControlBtn: ControlButton!
    @IBOutlet weak var shotClockResetBtn: ResetButton!
    @IBOutlet weak var sec24Btn: SmallButton!
    @IBOutlet weak var sec14Btn: SmallButton!
    @IBOutlet weak var sec120Btn: SmallButton!
    
    
    
    
    let userdefaults = UserDefaults.standard
    let TEAM_A: String  = "team_a"
    let TEAM_B: String  = "team_b"
    let SCORE_A: String = "score_a"
    let SCORE_B: String = "score_a"
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        statusBarView.backgroundColor = statusBarColor
        self.view.addSubview(statusBarView)
        
        self.view.backgroundColor = UIColor.black
        
        for i in 0...20 { //分設定(ゲームタイムピッカー用)
            gameTimeMinArray.append(String(format: "%02d", i))
        }
        
        for i in 0..<60 { //秒設定(ゲームタイムピッカー用)
            gameTimeSecArray.append(String(format: "%02d", i))
        }
        
        initScore()
        initGameTime()
        initShotClock()
        
        // SideMenu表示用スワイプ
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController()?.rearViewRevealWidth = 180
        
        userdefaults.set(teamALabel.text, forKey: TEAM_A)
        userdefaults.set(teamBLabel.text, forKey: TEAM_B)
        userdefaults.set(Int(scoreALabel.text ?? "0"),forKey: SCORE_A)
        userdefaults.set(Int(scoreBLabel.text ?? "0"),forKey: SCORE_B)
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - スコア
    func initScore() {
        
        teamALabel.text = "HOME"
        
        let teamNameHeight = self.view.frame.height*(7/10)
        
        teamALabel.center = CGPoint(x: self.view.frame.width*(1/4),
                                         y: teamNameHeight)
        
        let tapTeamA = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapTeamALabel))
        teamALabel.addGestureRecognizer(tapTeamA)
        
        teamBLabel.text = "GUEST"
        teamBLabel.center = CGPoint(x: self.view.frame.width*(3/4),
                                         y: teamNameHeight)
        
        let tapTeamB = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapTeamBLabel))
        teamBLabel.addGestureRecognizer(tapTeamB)
        
        
        let scoreLabelHeight = self.view.frame.height*(8/10)
        
        scoreALabel.center = CGPoint(x: self.view.frame.width*(1/4),
                                      y: scoreLabelHeight)
        
        let tapScoreA = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapScoreALabel))
        scoreALabel.addGestureRecognizer(tapScoreA)
        
        scoreBLabel.center = CGPoint(x: self.view.frame.width*(3/4),
                                     y: scoreLabelHeight)
        
        let tapScoreB = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapScoreBLabel))
        scoreBLabel.addGestureRecognizer(tapScoreB)
        
        scoreAMinusBtn.setTitle("-", for: .normal)
        scoreAMinusBtn.center = CGPoint(x: self.view.frame.width*(1/8), y: self.view.frame.height*(9/10))
        
        scoreAPlusBtn.setTitle("+", for: .normal)
        scoreAPlusBtn.center = CGPoint(x: self.view.frame.width*(3/8), y: self.view.frame.height*(9/10))
        
        scoreBMinusBtn.setTitle("-", for: .normal)
        scoreBMinusBtn.center = CGPoint(x: self.view.frame.width*(5/8), y: self.view.frame.height*(9/10))
        
        scoreBPlusBtn.setTitle("+", for: .normal)
        scoreBPlusBtn.center = CGPoint(x: self.view.frame.width*(7/8), y: self.view.frame.height*(9/10))

    }
    
    // チームAスコア
    @IBAction func tapScoreAMinusBtn(_ sender: UIButton) {
        if scoreA > 0 {
            scoreA -= 1
            scoreALabel.text = String(scoreA)
            userdefaults.set(scoreA, forKey: SCORE_A)
        }
    }
    
    @IBAction func tapScoreAPlusBtn(_ sender: UIButton) {
        if scoreA < 1000 {
            scoreA += 1
            scoreALabel.text = String(scoreA)
            userdefaults.set(scoreA, forKey: SCORE_A)
        }
    }
    
    // チームBスコア
    @IBAction func tapScoreBMinusBtn(_ sender: UIButton) {
        if scoreB > 0 {
            scoreB -= 1
            scoreBLabel.text = String(scoreB)
            userdefaults.set(scoreB, forKey: SCORE_B)
        }
    }
    
    @IBAction func tapScoreBPlusBtn(_ sender: UIButton) {
        if scoreB < 1000 {
            scoreB += 1
            scoreBLabel.text = String(scoreB)
            userdefaults.set(scoreB, forKey: SCORE_B)
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
    
    // チームA名前編集ダイアログ表示
    func openTeamNameAEditDialog() {
        let alert = UIAlertController(title: "Edit HOME Name", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.teamALabel.text = textField.text
                    self.userdefaults.set(textField.text, forKey: self.TEAM_A)
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
    
    // チームB名前編集ダイアログ表示
    func openTeamNameBEditDialog() {
        let alert = UIAlertController(title: "Edit GUEST Name", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.teamBLabel.text = textField.text
                    self.userdefaults.set(textField.text, forKey: self.TEAM_B)
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
        let alert = UIAlertController(title: "Edit HOME Score", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.scoreALabel.text = textField.text
                    self.scoreA = Int(textField.text!)!
                    self.userdefaults.set(Int(textField.text ?? "0"), forKey: self.SCORE_A)
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
    func openScoreBEditDialog() {
        let alert = UIAlertController(title: "Edit GUEST Score", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.scoreBLabel.text = textField.text
                    self.scoreB = Int(textField.text!)!
                    self.userdefaults.set(Int(textField.text ?? "0"), forKey: self.SCORE_B)
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
        gameMinLabel.center = CGPoint(x: self.view.frame.width*(1/3)-10,
                                      y: self.view.frame.height*0.5-gameMinLabel.bounds.height*0.5)
        gameMinLabel.font = UIFont.boldSystemFont(ofSize: 80)
        gameMinLabel.textColor = UIColor.yellow
        
        gameColonLabel.text = ":"
        gameColonLabel.textAlignment = .center
        gameColonLabel.bounds = CGRect(x: 0, y: 0, width: 30, height: 100)
        gameColonLabel.center = CGPoint(x: self.view.frame.width*(1/2),
                                        y: self.view.frame.height*0.5-gameColonLabel.bounds.height*0.5)
        gameColonLabel.font = UIFont.boldSystemFont(ofSize: 80)
        gameColonLabel.textColor = UIColor.yellow
        
        gameSecLabel.text = "00"
        gameSecLabel.textAlignment = .center
        gameSecLabel.bounds = BASE_DIGIT_RECT
        gameSecLabel.center = CGPoint(x: self.view.frame.width*(2/3)+10,
                                      y: self.view.frame.height*0.5-gameSecLabel.bounds.height*0.5)
        gameSecLabel.font = UIFont.boldSystemFont(ofSize: 80)
        gameSecLabel.textColor = UIColor.yellow
        
        toggleIsHiddenGameLabels()
        
        gameTimerControlBtn.setTitle("Start", for: .normal)
        gameTimerControlBtn.center = CGPoint(x: self.view.frame.width*(1/3), y: self.view.frame.height*(4/7))
        gameTimerControlBtn.backgroundColor = limegreen
        
        gameResetBtn.isEnabled = false
        gameResetBtn.center = CGPoint(x: self.view.frame.width*(2/3), y: self.view.frame.height*(4/7))
        
        gameSeconds = Int(gameMinLabel.text!)!*60
        gameSeconds += Int(gameSecLabel.text!)!
        
        let possessionLabelHight = self.view.frame.height*(4/7)
        
        possessionALabel.text = "◀"
        possessionALabel.center = CGPoint(x: self.view.frame.width*(1/8),
                                          y: possessionLabelHight)

        possessionALabel.alpha = 1
        let tapPossessionA = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapPossessionA))
        possessionALabel.addGestureRecognizer(tapPossessionA)
        
        possessionBLabel.text = "▶"
        possessionBLabel.center = CGPoint(x: self.view.frame.width*(7/8),
                                          y: possessionLabelHight)

        possessionBLabel.alpha = 0.5
        let tapPossessionB = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapPossessionB))
        possessionBLabel.addGestureRecognizer(tapPossessionB)
        
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
                gameTimerControlBtn.backgroundColor = gold
                gameResetBtn.isEnabled = true
                gameResetBtn.backgroundColor = UIColor.groupTableViewBackground
            
            case .STOP:
                gameTimer.invalidate()
                gameTimerControlBtn.setTitle("Resume", for: .normal)
                gameTimerControlBtn.backgroundColor = limegreen
                gameTimerStatus = .RESUME
            
            case .RESUME:
                runGameTimer()
                gameTimerControlBtn.setTitle("Stop", for: .normal)
                gameTimerControlBtn.backgroundColor = gold
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
        gameTimerControlBtn.backgroundColor = limegreen
        gameResetBtn.isEnabled = false
        gameResetBtn.backgroundColor = UIColor.white
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
        gameTimePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.7, height: 100))
        gameTimePicker.delegate = self
        gameTimePicker.dataSource = self
        gameTimePicker.center = CGPoint(x: self.view.frame.width*(1/2),
                                        y: self.view.frame.height*(1/2)-gameTimePicker.bounds.height*(1/2))
        gameTimePicker.selectRow(10, inComponent: 0, animated: true)
        gameTimePicker.selectRow(0, inComponent: 1, animated: true)
        
        gameTimePicker.setValue(UIColor.white, forKey: "textColor")
        
        let minLabel = UILabel()
        minLabel.text = "min"
        minLabel.textColor = .yellow
        minLabel.sizeToFit()
        
        minLabel.frame = CGRect(x: gameTimePicker.bounds.width*0.4 - minLabel.bounds.width/2,
                                y: gameTimePicker.bounds.height/2 - (minLabel.bounds.height/2),
                                width: minLabel.bounds.width,
                                height: minLabel.bounds.height)
        gameTimePicker.addSubview(minLabel)
        
        let secLabel = UILabel()
        secLabel.text = "sec"
        secLabel.textColor = .yellow
        secLabel.sizeToFit()
        secLabel.frame = CGRect(x: gameTimePicker.bounds.width*0.9 - secLabel.bounds.width/2,
                                y: gameTimePicker.bounds.height/2 - (secLabel.bounds.height/2),
                                width: secLabel.bounds.width,
                                height: secLabel.bounds.height)
        gameTimePicker.addSubview(secLabel)
        
        self.view.addSubview(gameTimePicker)
    }
    
    func openGameTimeOverDialog() {
        let alert = UIAlertController(title: "Game Time Over", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            self.gameTimerControlBtn.setTitle("Start", for: .normal)
            self.gameSeconds = 600
            self.gameTimerStatus = .START
            self.gameTimerControlBtn.backgroundColor = self.limegreen
            self.gameResetBtn.isEnabled = false
            self.gameResetBtn.backgroundColor = UIColor.white
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
    
    @objc func tapPossessionA(_ sender: UITapGestureRecognizer) {

        if possessionALabel.alpha == 0.5 {
            possessionALabel.alpha = 1
            possessionBLabel.alpha = 0.5
        } else {
            possessionALabel.alpha = 0.5
            possessionBLabel.alpha = 1
        }
    }
    
    @objc func tapPossessionB(_ sender: UITapGestureRecognizer) {
        
        if possessionBLabel.alpha == 0.5 {
            possessionALabel.alpha = 0.5
            possessionBLabel.alpha = 1
        } else {
            possessionALabel.alpha = 1
            possessionBLabel.alpha = 0.5
        }
    }
    
    // MARK: - ショットクロック
    func initShotClock() {
        shotClockLabel.text = String(shotSeconds)
        shotClockLabel.bounds = CGRect(x: 0, y: 0, width: 140, height: 90)
        shotClockLabel.center = CGPoint(x: self.view.frame.width*(1/2), y: self.view.frame.height*(1/7))
        shotClockLabel.font = UIFont.boldSystemFont(ofSize: 80)
        shotClockLabel.textColor = UIColor.green
        shotClockLabel.isUserInteractionEnabled = true
        
        let tapShotClock = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapShotClockLabel))
        shotClockLabel.addGestureRecognizer(tapShotClock)
        
        shotClockControlBtn.setTitle("Start", for: .normal)
        shotClockControlBtn.center = CGPoint(x: self.view.frame.width*(1/3), y: self.view.frame.height*(2/7))
        
        shotClockControlBtn.backgroundColor = limegreen
        
        shotClockResetBtn.center = CGPoint(x: self.view.frame.width*(2/3), y: self.view.frame.height*(2/7))
        shotClockResetBtn.isEnabled = false
        
        let btnPosX = self.view.frame.width*(1/2) + 80
        sec24Btn.setTitle("24", for: .normal)
        sec24Btn.frame = CGRect(x: btnPosX,
                                y: self.view.frame.height*(1/7) - sec24Btn.frame.height,
                                width: 30, height: 30)
        
        sec14Btn.setTitle("14", for: .normal)
        sec14Btn.frame = CGRect(x: btnPosX,
                                y: self.view.frame.height*(1/7),
                                width: 30, height: 30)
        
        sec120Btn.setTitle("120", for: .normal)
        sec120Btn.frame = CGRect(x: btnPosX + 40,
                                y: self.view.frame.height*(1/7) - sec120Btn.frame.height,
                                width: 30, height: 30)
    }
    
    @objc func tapShotClockLabel() {
        if shotClockStatus == .STOP {
            shotClockTimer.invalidate()
        }
        
        let alert = UIAlertController(title: "Edit Timer", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    if textField.text != "" {
                        self.shotClockLabel.text = textField.text
                        self.shotSeconds = Int(textField.text!)!
                    }
                }
            }
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = String(0)
            textField.text = self.shotClockLabel.text
            textField.keyboardType = UIKeyboardType.numberPad
        })
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // ショットクロックコントロールボタンタップ
    @IBAction func tapShotClockControlBtn(_ sender: UIButton) {
        switch shotClockStatus {
        case .START:
            runShotClockTimer()
            shotClockControlBtn.setTitle("Stop", for: .normal)
            shotClockStatus = .STOP
            shotClockControlBtn.backgroundColor = gold
            shotClockResetBtn.isEnabled = true
            shotClockResetBtn.backgroundColor = UIColor.groupTableViewBackground
        
        case .STOP:
            shotClockTimer.invalidate()
            shotClockControlBtn.setTitle("Resume", for: .normal)
            shotClockControlBtn.backgroundColor = limegreen
            shotClockStatus = .RESUME
        
        case .RESUME:
            runShotClockTimer()
            shotClockControlBtn.setTitle("Stop", for: .normal)
            shotClockControlBtn.backgroundColor = gold
            shotClockStatus = .STOP
        }
    }
    
    func runShotClockTimer(){
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
    
    // ショットクロックリセットボタンタップ
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
            shotClockControlBtn.setTitle("Start", for: .normal)
            shotClockStatus = .START
            shotClockControlBtn.backgroundColor = limegreen
            shotClockResetBtn.isEnabled = false
            shotClockResetBtn.backgroundColor = UIColor.white
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
    
    @IBAction func tapSec120(_ sender: SmallButton) {
        shotSeconds = 120
        shotClockLabel.text = "120"
    }
    
    func openShotClockTimeOverDialog() {
        
        let alert = UIAlertController(title: "Time Over", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            self.shotClockControlBtn.setTitle("Start", for: .normal)
            self.shotSeconds = 24
            self.shotClockLabel.text = String(self.shotSeconds)
            self.shotClockStatus = .START
            self.shotClockControlBtn.backgroundColor = self.limegreen
            self.shotClockResetBtn.isEnabled = false
            self.shotClockResetBtn.backgroundColor = UIColor.white
        })
        
        alert.addAction(okAction)
        
        alert.view.setNeedsLayout()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - ゲーム結果ダイアログ遷移前の設定
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameResultDialog" {
            let gameResultDialog = segue.destination as! GameResultDialogViewController
            gameResultDialog.status = "create"
            let newGame = Game()
            newGame.team_a = (teamALabel.text != nil) ? teamALabel.text! : "HOME"
            newGame.team_b = (teamBLabel.text != nil) ? teamBLabel.text! : "GUEST"
            newGame.score_a = (scoreALabel.text != nil) ? Int(scoreALabel.text!)! : 0
            newGame.score_b = (scoreBLabel.text != nil) ? Int(scoreBLabel.text!)! : 0
            newGame.played_at = Date()
            gameResultDialog.game = newGame
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70))
        label.textAlignment = .center
        label.textColor = .yellow
        label.font =  UIFont.boldSystemFont(ofSize: 30)
        
        if component == 0 {
            label.text = gameTimeMinArray[row]
        } else if component == 1 {
            label.text = gameTimeSecArray[row]
        }
        
        return label
    }
    
    func setGameSeconds() {
        let min = Int(self.gameMinLabel.text!)
        let sec = Int(self.gameSecLabel.text!)
        self.gameSeconds = min!*60 + sec!
        self.oldGameSeconds = gameSeconds
    }
}

