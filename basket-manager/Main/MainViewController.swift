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
    
    // MARK: - スコア変数
    // スコアA
    var scoreA: Int = 0
    @IBOutlet weak var teamALabel: TeamLabel!
    @IBOutlet weak var scoreALabel: ScoreLabel!
    @IBOutlet weak var scoreAMinusBtn: ScoreSmallButton!
    @IBOutlet weak var scoreAPlusBtn: ScoreSmallButton!
    
    // スコアB
    var scoreB: Int = 0
    @IBOutlet weak var teamBLabel: TeamLabel!
    @IBOutlet weak var scoreBLabel: ScoreLabel!
    @IBOutlet weak var scoreBMinusBtn: ScoreSmallButton!
    @IBOutlet weak var scoreBPlusBtn: ScoreSmallButton!
    
    // MARK: - ゲームタイマー変数
    var gameTimer: Timer!
    var startGameTime = Date()
    var gameSeconds = 600
    var oldGameSeconds = 600
    var gameTimeMinArray: [String] = []
    var gameTimeSecArray: [String] = []
    var gameTimePicker = UIPickerView()
    var gameTimePickerMinLabel = UILabel()
    var gameTimePickerSecLabel = UILabel()
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

    @IBOutlet weak var possessionAImage: PossesImage!
    
    @IBOutlet weak var possessionBImage: PossesImage!
    var isPossessionA = true
    
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
    @IBOutlet weak var sec24Btn: ShotClockSmallButton!
    @IBOutlet weak var sec14Btn: ShotClockSmallButton!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        for i in 0...20 { //分設定(ゲームタイムピッカー用)
            gameTimeMinArray.append(String(format: "%02d", i))
        }
        
        for i in 0..<60 { //秒設定(ゲームタイムピッカー用)
            gameTimeSecArray.append(String(format: "%02d", i))
        }
        
        initScoreViewText()
        registerGesturerecognizer()
        
        initGameTimeLabelText()
        initGameTimePicker()
        
        initShotClockText()
        
        userdefaults.set(teamALabel.text, forKey: TEAM_A)
        userdefaults.set(teamBLabel.text, forKey: TEAM_B)
        userdefaults.set(Int(scoreALabel.text ?? "0"),forKey: SCORE_A)
        userdefaults.set(Int(scoreBLabel.text ?? "0"),forKey: SCORE_B)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            self.setViews_Portrait()
        case .landscapeLeft, .landscapeRight:
            self.setViews_Landscape()
        default:
            self.setViews_Portrait()
        }
    }
    
    func registerGesturerecognizer() {
        let tapTeamA = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapTeamALabel))
        teamALabel.addGestureRecognizer(tapTeamA)
        
        let tapTeamB = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapTeamBLabel))
        teamBLabel.addGestureRecognizer(tapTeamB)
        
        let tapScoreA = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapScoreALabel))
        scoreALabel.addGestureRecognizer(tapScoreA)
        
        let tapScoreB = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapScoreBLabel))
        scoreBLabel.addGestureRecognizer(tapScoreB)
        
        let tapShotClock = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapShotClockLabel))
        shotClockLabel.addGestureRecognizer(tapShotClock)
        
        let tapPossessionA = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapPossessionA))
        possessionAImage.addGestureRecognizer(tapPossessionA)
        
        let tapPossessionB = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapPossessionB))
        possessionBImage.addGestureRecognizer(tapPossessionB)
    }
    
    func setViews_Portrait() {
        setScoreViewPosition_Portrait()
        setGameTimeLabelPosition_Portrait()
        setGameTimePickerPosition_Portrait()
        setShotClockPosition_Portrait()
        
    }
    
    func setViews_Landscape() {
        setScoreViewPosition_Landscape()
        setGameTimeLabelPosition_Landscape()
        setGameTimePickerPosition_Landscape()
        setShotClockPosition_Landscape()
    }
    
    // MARK: - スコア
    func initScoreViewText() {
        teamALabel.text = "HOME"
        teamBLabel.text = "GUEST"
        let upButtonImage = UIImage(named:"up-button")!
        let downButtonImage = UIImage(named:"down-button")!
        scoreAMinusBtn.setImage(downButtonImage, for: .normal)
        scoreAPlusBtn.setImage(upButtonImage, for: .normal)
        scoreBMinusBtn.setImage(downButtonImage, for: .normal)
        scoreBPlusBtn.setImage(upButtonImage, for: .normal)
    }
    
    func setScoreViewPosition_Portrait() {
        
        let teamNameHeight = self.view.frame.height*(7/10)
        teamALabel.center = CGPoint(x: self.view.frame.width*(1/4),
                                         y: teamNameHeight)
        
        teamBLabel.center = CGPoint(x: self.view.frame.width*(3/4),
                                         y: teamNameHeight)
        
        let scoreLabelHeight = self.view.frame.height*(8/10)
        
        scoreALabel.center = CGPoint(x: self.view.frame.width*(1/4),
                                      y: scoreLabelHeight)
        
        scoreBLabel.center = CGPoint(x: self.view.frame.width*(3/4),
                                     y: scoreLabelHeight)
        
        scoreAMinusBtn.center = CGPoint(x: self.view.frame.width*(1/8), y: self.view.frame.height*(9/10))
        
        scoreAPlusBtn.center = CGPoint(x: self.view.frame.width*(3/8), y: self.view.frame.height*(9/10))
        
        scoreBMinusBtn.center = CGPoint(x: self.view.frame.width*(5/8), y: self.view.frame.height*(9/10))
        
        scoreBPlusBtn.center = CGPoint(x: self.view.frame.width*(7/8), y: self.view.frame.height*(9/10))

    }
    
    func setScoreViewPosition_Landscape() {
        
        let teamNameHeight = self.view.frame.height*(9/16)
        
        teamALabel.center = CGPoint(x: self.view.frame.width*(1/8),
                                    y: teamNameHeight)
        
        teamBLabel.center = CGPoint(x: self.view.frame.width*(7/8),
                                    y: teamNameHeight)

        let scoreLabelHeight = self.view.frame.height*(3/4)

        scoreALabel.center = CGPoint(x: self.view.frame.width*(1/8),
                                     y: scoreLabelHeight)

        scoreBLabel.center = CGPoint(x: self.view.frame.width*(7/8),
                                     y: scoreLabelHeight)

        let scoreButtonHeight = self.view.frame.height*(15/16)
        
        scoreAMinusBtn.center = CGPoint(x: self.view.frame.width*(1/16), y: scoreButtonHeight)

        scoreAPlusBtn.center = CGPoint(x: self.view.frame.width*(3/16), y: scoreButtonHeight)

        scoreBMinusBtn.center = CGPoint(x: self.view.frame.width*(13/16), y: scoreButtonHeight)

        scoreBPlusBtn.center = CGPoint(x: self.view.frame.width*(15/16), y: scoreButtonHeight)
        
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
    
    // チームA名前編集ダイアログ表示
    @objc func tapTeamALabel(_ sender: UITapGestureRecognizer) {
        AlertDialog.showTeamNameEdit(title: "Edit HOME Name", team: TEAM_A, teamLabel: teamALabel, viewController: self)
    }
    
    // チームB名前編集ダイアログ表示
    @objc func tapTeamBLabel(_ sender: UITapGestureRecognizer) {
        AlertDialog.showTeamNameEdit(title: "Edit GUEST Name", team: TEAM_B, teamLabel: teamBLabel, viewController: self)
    }
    
    @objc func tapScoreALabel(_ sender: UITapGestureRecognizer) {
        openScoreAEditDialog()
    }
    
    @objc func tapScoreBLabel(_ sender: UITapGestureRecognizer) {
        openScoreBEditDialog()
    }
    
    // スコアAダイアログ表示
    func openScoreAEditDialog() {
        // TODO: AlertDialog共通化(Int型のscoreが共通化先で再代入できない)
//        AlertDialog.showScoreEdit(title: "Edit HOME Score", team: TEAM_A, scoreLabel: scoreALabel, &scoreA: Int,  viewController: self)
        
        let alert = UIAlertController(title: "Edit HOME Score", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    self.scoreALabel.text = textField.text
                    self.scoreA = Int(textField.text!)!
                    userdefaults.set(Int(textField.text ?? "0"), forKey: SCORE_A)
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
                    userdefaults.set(Int(textField.text ?? "0"), forKey: SCORE_B)
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
    func initGameTimeLabelText() {
        gameMinLabel.text = "10"
        gameMinLabel.textAlignment = .center
        gameMinLabel.bounds = BASE_DIGIT_RECT
        gameMinLabel.textColor = UIColor.yellow
        gameMinLabel.font = UIFont(name: "DigitalDismay", size: 100)
        
        gameColonLabel.text = ":"
        gameColonLabel.textAlignment = .center
        gameColonLabel.bounds = CGRect(x: 0, y: 0, width: 30, height: 100)
        gameColonLabel.font = UIFont(name: "DigitalDismay", size: 100)
        gameColonLabel.textColor = UIColor.yellow
        
        gameSecLabel.text = "00"
        gameSecLabel.textAlignment = .center
        gameSecLabel.bounds = BASE_DIGIT_RECT
        gameSecLabel.font = UIFont(name: "DigitalDismay", size: 100)
        gameSecLabel.textColor = UIColor.yellow
        
        toggleIsHiddenGameLabels()
        
        gameTimerControlBtn.setTitle("Start", for: .normal)
        gameTimerControlBtn.tintColor = .limegreen
        
        gameResetBtn.isEnabled = false
        
        gameSeconds = Int(gameMinLabel.text!)!*60
        gameSeconds += Int(gameSecLabel.text!)!
        
    }
    func setGameTimeLabelPosition_Portrait() {
        
        gameMinLabel.center = CGPoint(x: self.view.frame.width*(1/3)-10,
                                      y: self.view.frame.height*0.5-gameMinLabel.bounds.height*0.5)
        
        
        
        gameColonLabel.center = CGPoint(x: self.view.frame.width*(1/2),
                                        y: self.view.frame.height*0.5-gameColonLabel.bounds.height*0.5)
        
        gameSecLabel.center = CGPoint(x: self.view.frame.width*(2/3)+10,
                                      y: self.view.frame.height*0.5-gameSecLabel.bounds.height*0.5)
        
        gameTimerControlBtn.center = CGPoint(x: self.view.frame.width*(1/3), y: self.view.frame.height*(4/7))
        
        gameResetBtn.center = CGPoint(x: self.view.frame.width*(2/3), y: self.view.frame.height*(4/7))
        
        let possessionLabelHight = self.view.frame.height*(4/7)
        
        possessionAImage.center = CGPoint(x: self.view.frame.width*(1/8),
                                          y: possessionLabelHight)
        
        possessionBImage.center = CGPoint(x: self.view.frame.width*(7/8),
                                          y: possessionLabelHight)
        
    }
    
    func setGameTimeLabelPosition_Landscape() {
        gameMinLabel.center = CGPoint(x: self.view.frame.width*(3/8),
                                      y: self.view.frame.height*(1/4))
        
        gameColonLabel.center = CGPoint(x: self.view.frame.width*(1/2),
                                        y: self.view.frame.height*(1/4))
        
        gameSecLabel.center = CGPoint(x: self.view.frame.width*(5/8),
                                      y: self.view.frame.height*(1/4))
        
        let gameTimeButtonY = self.view.frame.height*(7/16)
        
        gameTimerControlBtn.center = CGPoint(x: self.view.frame.width*(3/8), y: gameTimeButtonY)
        
        gameResetBtn.center = CGPoint(x: self.view.frame.width*(5/8), y: gameTimeButtonY)
        
        let possessionLabelY = self.view.frame.height*(1/4)
        
        possessionAImage.center = CGPoint(x: self.view.frame.width*(1/8),
                                          y: possessionLabelY)
        
        possessionBImage.center = CGPoint(x: self.view.frame.width*(7/8),
                                          y: possessionLabelY)
    }
    
    func initGameTimePicker() {
        gameTimePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.7, height: 100))
        gameTimePicker.delegate = self
        gameTimePicker.dataSource = self
        
        gameTimePicker.selectRow(10, inComponent: 0, animated: true)
        gameTimePicker.selectRow(0, inComponent: 1, animated: true)
        
        gameTimePicker.setValue(UIColor.white, forKey: "textColor")
        
        gameTimePickerMinLabel.text = "min"
        gameTimePickerMinLabel.textColor = .yellow
        gameTimePickerMinLabel.sizeToFit()
        
        gameTimePicker.addSubview(gameTimePickerMinLabel)
        
        gameTimePickerSecLabel.text = "sec"
        gameTimePickerSecLabel.textColor = .yellow
        gameTimePickerSecLabel.sizeToFit()
        
        gameTimePicker.addSubview(gameTimePickerSecLabel)
        
        self.view.addSubview(gameTimePicker)
    }
    
    func setGameTimePickerPosition_Portrait() {
        
        gameTimePicker.center = CGPoint(x: self.view.frame.width*(1/2),
                                        y: self.view.frame.height*(1/2)-gameTimePicker.bounds.height*(1/2))
        
        gameTimePickerMinLabel.frame = CGRect(x: gameTimePicker.bounds.width*0.4 - gameTimePickerMinLabel.bounds.width/2,
                                y: gameTimePicker.bounds.height/2 - (gameTimePickerMinLabel.bounds.height/2),
                                width: gameTimePickerMinLabel.bounds.width,
                                height: gameTimePickerMinLabel.bounds.height)
        
        gameTimePickerSecLabel.frame = CGRect(x: gameTimePicker.bounds.width*0.9 - gameTimePickerSecLabel.bounds.width/2,
                                y: gameTimePicker.bounds.height/2 - (gameTimePickerSecLabel.bounds.height/2),
                                width: gameTimePickerSecLabel.bounds.width,
                                height: gameTimePickerSecLabel.bounds.height)
        
    }
    
    func setGameTimePickerPosition_Landscape() {
        gameTimePicker.center = CGPoint(x: self.view.frame.width*(1/2),
                                        y: self.view.frame.height*(1/4))
        
        gameTimePickerMinLabel.frame = CGRect(x: gameTimePicker.bounds.width*0.4 - gameTimePickerMinLabel.bounds.width/2,
                                              y: gameTimePicker.bounds.height/2 - (gameTimePickerMinLabel.bounds.height/2),
                                              width: gameTimePickerMinLabel.bounds.width,
                                              height: gameTimePickerMinLabel.bounds.height)
        
        gameTimePickerSecLabel.frame = CGRect(x: gameTimePicker.bounds.width*0.9 - gameTimePickerSecLabel.bounds.width/2,
                                              y: gameTimePicker.bounds.height/2 - (gameTimePickerSecLabel.bounds.height/2),
                                              width: gameTimePickerSecLabel.bounds.width,
                                              height: gameTimePickerSecLabel.bounds.height)
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
                gameTimerControlBtn.tintColor = .gold
                gameResetBtn.isEnabled = true
            
            case .STOP:
                gameTimer.invalidate()
                gameTimerControlBtn.setTitle("Resume", for: .normal)
                gameTimerControlBtn.tintColor = .limegreen
                gameTimerStatus = .RESUME
            
            case .RESUME:
                runGameTimer()
                gameTimerControlBtn.setTitle("Stop", for: .normal)
                gameTimerControlBtn.tintColor = .gold
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
        gameTimerControlBtn.tintColor = .limegreen
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
    
    func openGameTimeOverDialog() {
        AlertDialog.showTimeover(title: "Game Time Over", viewController: self) {
            self.gameTimer.invalidate()
            self.gameSeconds = self.oldGameSeconds
            self.showGameTime()
            self.gameTimerControlBtn.setTitle("Start", for: .normal)
            self.gameTimerStatus = .START
            self.gameTimerControlBtn.tintColor = .limegreen
            self.gameResetBtn.isEnabled = false
            self.toggleIsHiddenGameLabels()
            self.gameTimePicker.isHidden = !self.gameTimePicker.isHidden
        }
        
    }
    
    func toggleIsHiddenGameLabels() {
        gameMinLabel.isHidden = !gameMinLabel.isHidden
        gameColonLabel.isHidden = !gameColonLabel.isHidden
        gameSecLabel.isHidden = !gameSecLabel.isHidden
    }
    
    @objc func tapPossessionA(_ sender: UITapGestureRecognizer) {

        togglePossession()
        
    }
    
    @objc func tapPossessionB(_ sender: UITapGestureRecognizer) {
        togglePossession()
    }
    
    func togglePossession() {
        if isPossessionA {
            possessionAImage.image = UIImage(named: "posses-a-inactive")
            possessionBImage.image = UIImage(named: "posses-b-active")
        } else {
            possessionAImage.image = UIImage(named: "posses-a-active")
            possessionBImage.image = UIImage(named: "posses-b-inactive")
        }
        
        isPossessionA = !isPossessionA
    }
    
    // MARK: - ショットクロック
    func initShotClockText() {
        shotClockLabel.text = String(shotSeconds)
        shotClockLabel.bounds = CGRect(x: 0, y: 0, width: 140, height: 90)
        shotClockLabel.font = UIFont(name: "DigitalDismay", size: 100)
        shotClockLabel.textColor = UIColor.green
        shotClockLabel.isUserInteractionEnabled = true
        
        shotClockControlBtn.setTitle("Start", for: .normal)
        shotClockResetBtn.isEnabled = false
        
        sec24Btn.setTitle("24", for: .normal)
        sec14Btn.setTitle("14", for: .normal)
    }
    
    func setShotClockPosition_Portrait() {
        
        shotClockLabel.center = CGPoint(x: self.view.frame.width*(1/2), y: self.view.frame.height*(1/7))
        
        shotClockControlBtn.center = CGPoint(x: self.view.frame.width*(1/3), y: self.view.frame.height*(2/7))
    
        shotClockResetBtn.center = CGPoint(x: self.view.frame.width*(2/3), y: self.view.frame.height*(2/7))
        
        
        let btnPosX = self.view.frame.width*(1/2) + 80
        
        sec24Btn.frame = CGRect(x: btnPosX,
                                y: self.view.frame.height*(1/7) - sec24Btn.frame.height,
                                width: 30, height: 30)
        
        sec14Btn.frame = CGRect(x: btnPosX,
                                y: self.view.frame.height*(1/7),
                                width: 30, height: 30)
    }
    
    func setShotClockPosition_Landscape() {
        shotClockLabel.center = CGPoint(x: self.view.frame.width*(1/2), y: self.view.frame.height*(3/4))
        
        let shotClockButtonY = self.view.frame.height*(15/16)
        
        shotClockControlBtn.center = CGPoint(x: self.view.frame.width*(3/8), y: shotClockButtonY)
        
        shotClockResetBtn.center = CGPoint(x: self.view.frame.width*(5/8), y: shotClockButtonY)
        
        let secButtonBaseX = self.view.frame.width*(5/8)
        
        sec24Btn.center = CGPoint(x: secButtonBaseX+20, y: self.view.frame.height*(5/8)+20)
        sec14Btn.center = CGPoint(x: secButtonBaseX+20, y: self.view.frame.height*(7/8)-20)
        
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
            shotClockControlBtn.tintColor = .gold
            shotClockResetBtn.isEnabled = true
        
        case .STOP:
            shotClockTimer.invalidate()
            shotClockControlBtn.setTitle("Resume", for: .normal)
            shotClockControlBtn.tintColor = .limegreen
            shotClockStatus = .RESUME
        
        case .RESUME:
            runShotClockTimer()
            shotClockControlBtn.setTitle("Stop", for: .normal)
            shotClockControlBtn.tintColor = .gold
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
            shotClockControlBtn.tintColor = .limegreen
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
        AlertDialog.showTimeover(title: "Shot Clock Over", viewController: self) {
            self.shotClockControlBtn.setTitle("Start", for: .normal)
            self.shotSeconds = 24
            self.shotClockLabel.text = String(self.shotSeconds)
            self.shotClockStatus = .START
            self.shotClockControlBtn.tintColor = .limegreen
            self.shotClockResetBtn.isEnabled = false
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
        label.font =  UIFont(name: "DigitalDismay", size: 30)
        
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

