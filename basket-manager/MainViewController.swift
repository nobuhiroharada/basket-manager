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
    
    var shotClockView: ShotClockView!
    var gameTimeView: GameTimeView!
    var scoreView: ScoreView!
    
    
    
    // MARK: - ゲームタイムピッカー変数
    var gameTimeMinArray: [String] = []
    var gameTimeSecArray: [String] = []
    var gameTimePicker = UIPickerView()
    var gameTimePickerMinLabel = UILabel()
    var gameTimePickerSecLabel = UILabel()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shotClockView = ShotClockView()
        gameTimeView = GameTimeView()
        scoreView = ScoreView()
        
        
        scoreView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gameTimeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shotClockView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        checkOrientation(frame: self.view.frame)
        
        self.view.addSubview(shotClockView)
        self.view.addSubview(gameTimeView)
        self.view.addSubview(scoreView)

        self.view.backgroundColor = UIColor.black

        for i in 0...20 { //分設定(ゲームタイムピッカー用)
            gameTimeMinArray.append(String(format: "%02d", i))
        }

        for i in 0..<60 { //秒設定(ゲームタイムピッカー用)
            gameTimeSecArray.append(String(format: "%02d", i))
        }

        gameTimePicker.delegate = self
        gameTimePicker.dataSource = self
        
        addButtonAction()
        registerGesturerecognizer()

        initGameTimePicker()
//
//        userdefaults.set(teamLabelA.text, forKey: TEAM_A)
//        userdefaults.set(teamLabelB.text, forKey: TEAM_B)
//        userdefaults.set(Int(scoreLabelA.text ?? "0"),forKey: SCORE_A)
//        userdefaults.set(Int(scoreLabelB.text ?? "0"),forKey: SCORE_B)
//
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        checkOrientation(frame: self.view.frame)
        
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            setViews_portrait()
            
        case .landscapeLeft, .landscapeRight:
            setViews_landscape()
            
        default:
            setViews_portrait()
        }
    }
    
    func checkOrientation(frame: CGRect) {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            shotClockView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*(1/3))
            
            gameTimeView.frame = CGRect(x: 0, y: frame.height*(1/3), width: frame.width, height: frame.height*(1/3))
            
            scoreView.frame = CGRect(x: 0, y: frame.height*(2/3), width: frame.width, height: frame.height*(1/3))
            
        case .landscapeLeft, .landscapeRight:
            
            let shotClockViewLandscapeW: CGFloat = 240.0
            shotClockView.frame = CGRect(x: frame.width*(1/2)-120, y: frame.height*(1/2), width: shotClockViewLandscapeW, height: frame.height*(1/2))

            self.view.bringSubviewToFront(shotClockView)
            
            
            gameTimeView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*(1/2))
            
            
            scoreView.frame = CGRect(x: 0, y: frame.height*(1/2), width: frame.width, height: frame.height*(1/2))

        default:
            shotClockView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*(1/3))
            
            gameTimeView.frame = CGRect(x: 0, y: frame.height*(1/3), width: frame.width, height: frame.height*(1/3))
            
            scoreView.frame = CGRect(x: 0, y: frame.height*(2/3), width: frame.width, height: frame.height*(1/3))
        }
    }
    
    
    func addButtonAction() {
        scoreView.scoreMinusButtonA.addTarget(self, action: #selector(MainViewController.scoreMinusButtonA_touched), for: .touchUpInside)
        
        scoreView.scorePlusButtonA.addTarget(self, action: #selector(MainViewController.scorePlusButtonA_touched), for: .touchUpInside)
        
        scoreView.scoreMinusButtonB.addTarget(self, action: #selector(MainViewController.scoreMinusButtonB_touched), for: .touchUpInside)
        
        scoreView.scorePlusButtonB.addTarget(self, action: #selector(MainViewController.scorePlusButtonB_touched), for: .touchUpInside)
        
        shotClockView.sec24Button.addTarget(self, action: #selector(MainViewController.sec24Button_tapped), for: .touchUpInside)
        
        shotClockView.sec14Button.addTarget(self, action: #selector(MainViewController.sec14Button_tapped), for: .touchUpInside)
        
        
        shotClockView.controlButton.addTarget(self, action: #selector(MainViewController.shotClockControlButton_tapped), for: .touchUpInside)
        
        shotClockView.resetButton.addTarget(self, action: #selector(MainViewController.shotClockResetButton_tapped), for: .touchUpInside)
        
        gameTimeView.gameControlButton.addTarget(self, action: #selector(MainViewController.gameControlButton_tapped), for: .touchUpInside)
        
        gameTimeView.gameResetButton.addTarget(self, action: #selector(MainViewController.gameResetButton_tapped), for: .touchUpInside)
    }
    
    func registerGesturerecognizer() {
        let tapTeamA = UITapGestureRecognizer(target: self, action: #selector(MainViewController.teamLabelA_tapped))
        scoreView.teamLabelA.addGestureRecognizer(tapTeamA)
        
        let tapTeamB = UITapGestureRecognizer(target: self, action: #selector(MainViewController.teamLabelB_tapped))
        scoreView.teamLabelB.addGestureRecognizer(tapTeamB)

        let tapScoreA = UITapGestureRecognizer(target: self, action: #selector(MainViewController.scoreLabelA_tapped))
        scoreView.scoreLabelA.addGestureRecognizer(tapScoreA)
        
        let tapScoreB = UITapGestureRecognizer(target: self, action: #selector(MainViewController.scoreLabelB_tapped))
        scoreView.scoreLabelB.addGestureRecognizer(tapScoreB)

        let tapShotClock = UITapGestureRecognizer(target: self, action: #selector(MainViewController.shotClockLabel_tapped))
        shotClockView.shotClockLabel.addGestureRecognizer(tapShotClock)

        let tapPossessionA = UITapGestureRecognizer(target: self, action: #selector(MainViewController.possessionA_tapped))
        gameTimeView.possessionImageA.addGestureRecognizer(tapPossessionA)
        
        let tapPossessionB = UITapGestureRecognizer(target: self, action: #selector(MainViewController.possessionB_tapped))
        gameTimeView.possessionImageB.addGestureRecognizer(tapPossessionB)
    }
    
    func setViews_portrait() {

        self.scoreView.portrait(frame: scoreView.frame)
        self.gameTimeView.portrait(frame: gameTimeView.frame)
        self.shotClockView.portrait(frame: shotClockView.frame)
        
        setGameTimePickerPosition_Portrait()
        
    }
    
    func setViews_landscape() {
        self.scoreView.landscape(frame: scoreView.frame)
        self.gameTimeView.landscape(frame: gameTimeView.frame)
        self.shotClockView.landscape(frame: shotClockView.frame)
        
        setGameTimePickerPosition_Landscape()
        
    }
    
    
    @objc func scoreMinusButtonA_touched(_ sender: UIButton) {
        if scoreView.scoreA > 0 {
            scoreView.scoreA -= 1
            scoreView.scoreLabelA.text = String(scoreView.scoreA)
            userdefaults.set(scoreView.scoreA, forKey: SCORE_A)
        }
    }
    
    @objc func scorePlusButtonA_touched(_ sender: UIButton) {
        if scoreView.scoreA < 1000 {
            scoreView.scoreA += 1
            scoreView.scoreLabelA.text = String(scoreView.scoreA)
            userdefaults.set(scoreView.scoreA, forKey: SCORE_A)
        }
    }
    
    @objc func scoreMinusButtonB_touched(_ sender: UIButton) {
        if scoreView.scoreB > 0 {
            scoreView.scoreB -= 1
            scoreView.scoreLabelB.text = String(scoreView.scoreB)
            userdefaults.set(scoreView.scoreB, forKey: SCORE_B)
        }
    }
    
    @objc func scorePlusButtonB_touched(_ sender: UIButton) {
        if scoreView.scoreB < 1000 {
            scoreView.scoreB += 1
            scoreView.scoreLabelB.text = String(scoreView.scoreB)
            userdefaults.set(scoreView.scoreB, forKey: SCORE_B)
        }
    }
    
    // チームA名前編集ダイアログ表示
    @objc func teamLabelA_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showTeamNameEdit(title: "Edit HOME Name", team: TEAM_A, teamLabel: scoreView.teamLabelA, viewController: self)
    }
    
    // チームB名前編集ダイアログ表示
    @objc func teamLabelB_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showTeamNameEdit(title: "Edit GUEST Name", team: TEAM_B, teamLabel: scoreView.teamLabelB, viewController: self)
    }
    
    @objc func scoreLabelA_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showScoreEdit(title: "Edit HOME Score", team: TEAM_A, scoreView: scoreView, viewController: self)
    }
    
    @objc func scoreLabelB_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showScoreEdit(title: "Edit GUEST Score", team: TEAM_B, scoreView: scoreView, viewController: self)
    }
    
    func initGameTimePicker() {
        gameTimePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.6, height: 100))
        gameTimePicker.delegate = self
        gameTimePicker.dataSource = self
        
//        gameTimePicker.backgroundColor = .blue
        
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
                                        y: self.view.frame.height*(1/2))
        
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
    @objc func gameControlButton_tapped(_ sender: UIButton) {

        switch gameTimeView.gameTimerStatus {
            case .START:
                self.runGameTimer()
                gameTimeView.gameControlButton.setTitle("Stop", for: .normal)
                gameTimeView.gameTimerStatus = .STOP
                gameTimeView.toggleGameLabels()
                self.gameTimePicker.isHidden = !self.gameTimePicker.isHidden
                gameTimeView.gameControlButton.setTitleColor(.gold, for: .normal)
                gameTimeView.gameResetButton.isEnabled = true

            case .STOP:
                gameTimeView.gameTimer.invalidate()
                gameTimeView.gameControlButton.setTitle("Resume", for: .normal)
                gameTimeView.gameControlButton.setTitleColor(.limegreen, for: .normal)
                gameTimeView.gameTimerStatus = .RESUME

            case .RESUME:
                self.runGameTimer()
                gameTimeView.gameControlButton.setTitle("Stop", for: .normal)
                gameTimeView.gameControlButton.setTitleColor(.gold, for: .normal)
                gameTimeView.gameTimerStatus = .STOP
        }
    }
    
    // ゲームタイムリセットボタン押下
    @objc func gameResetButton_tapped(_ sender: UIButton) {
        gameTimeView.gameTimer.invalidate()
        gameTimeView.gameSeconds = gameTimeView.oldGameSeconds
        self.showGameTime()
        gameTimeView.gameControlButton.setTitle("Start", for: .normal)
        gameTimeView.gameResetButton.setTitleColor(.limegreen, for: .normal)
        gameTimeView.gameTimerStatus = .START
        gameTimeView.toggleGameLabels()
        self.gameTimePicker.isHidden = !self.gameTimePicker.isHidden
        gameTimeView.gameResetButton.isEnabled = false
    }

    func runGameTimer(){
        gameTimeView.gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.gameTimerCount),
            userInfo: nil,
            repeats: true)
    }

    @objc func gameTimerCount() {
        if gameTimeView.gameSeconds < 1 {
            gameTimeView.gameTimer.invalidate()
            gameTimeView.gameSecLabel.text = "00"
            self.openGameTimeOverDialog()
        } else {
            gameTimeView.gameSeconds -= 1
            self.showGameTime()
        }
    }

    func showGameTime() {
        let min = gameTimeView.gameSeconds/60
        let sec = gameTimeView.gameSeconds%60
        gameTimeView.gameMinLabel.text = String(format: "%02d", min)
        gameTimeView.gameSecLabel.text = String(format: "%02d", sec)
    }

    func openGameTimeOverDialog() {
        AlertDialog.showTimeover(title: "Game Time Over", viewController: self) {
            self.gameTimeView.gameTimer.invalidate()
            self.gameTimeView.gameSeconds = self.gameTimeView.oldGameSeconds
            self.showGameTime()
            self.gameTimeView.gameControlButton.setTitle("Start", for: .normal)
            self.gameTimeView.gameTimerStatus = .START
            self.gameTimeView.gameControlButton.setTitleColor(.limegreen, for: .normal)
            self.gameTimeView.gameResetButton.isEnabled = false
            self.gameTimeView.toggleGameLabels()
            self.gameTimePicker.isHidden = !self.gameTimePicker.isHidden
        }

    }
    
    @objc func possessionA_tapped(_ sender: UITapGestureRecognizer) {
        togglePossession()
    }
    
    @objc func possessionB_tapped(_ sender: UITapGestureRecognizer) {
        togglePossession()
    }
    
    func togglePossession() {
        if gameTimeView.isPossessionA {
            gameTimeView.possessionImageA.image = UIImage(named: "posses-a-inactive")
            gameTimeView.possessionImageB.image = UIImage(named: "posses-b-active")
        } else {
            gameTimeView.possessionImageA.image = UIImage(named: "posses-a-active")
            gameTimeView.possessionImageB.image = UIImage(named: "posses-b-inactive")
        }
        
        gameTimeView.isPossessionA = !gameTimeView.isPossessionA
    }
    
    @objc func shotClockLabel_tapped() {

        if shotClockView.shotClockStatus == .STOP {
            shotClockView.shotClockTimer.invalidate()
        }

        AlertDialog.showShotClockEdit(title: "Edit Timer", shotClockView: shotClockView, viewController: self)
        
    }
    
    // ショットクロックコントロールボタンタップ
    @objc func shotClockControlButton_tapped(_ sender: UIButton) {
        switch shotClockView.shotClockStatus {
        case .START:
            runShotClockTimer()
            shotClockView.controlButton.setTitle("Stop", for: .normal)
            shotClockView.controlButton.setTitleColor(.gold, for: .normal)
            shotClockView.shotClockStatus = .STOP
            shotClockView.resetButton.isEnabled = true

        case .STOP:
            shotClockView.shotClockTimer.invalidate()
            shotClockView.controlButton.setTitle("Resume", for: .normal)
            shotClockView.controlButton.setTitleColor(.limegreen, for: .normal)
            shotClockView.shotClockStatus = .RESUME

        case .RESUME:
            runShotClockTimer()
            shotClockView.controlButton.setTitle("Stop", for: .normal)
            shotClockView.controlButton.setTitleColor(.gold, for: .normal)
            shotClockView.shotClockStatus = .STOP
        }
    }

    func runShotClockTimer(){
        shotClockView.shotClockTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.shotClockCount),
            userInfo: nil,
            repeats: true)
    }

    @objc func shotClockCount() {
        if shotClockView.shotSeconds < 1 {
            shotClockView.shotClockTimer.invalidate()
            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
            openShotClockTimeOverDialog()
        } else {
            shotClockView.shotSeconds -= 1
            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
        }
    }

    // ショットクロックリセットボタンタップ
    @objc func shotClockResetButton_tapped(_ sender: UIButton) {
        switch shotClockView.shotClockStatus {
        case .START:
            return
        case .STOP:
            shotClockView.shotSeconds = 24
            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
        case .RESUME:
            shotClockView.shotClockTimer.invalidate()
            shotClockView.shotSeconds = 24
            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
            shotClockView.controlButton.setTitle("Start", for: .normal)
            shotClockView.controlButton.setTitleColor(.limegreen, for: .normal)
            shotClockView.shotClockStatus = .START
            
            shotClockView.resetButton.isEnabled = false
        }
    }

    // 24秒セットボタンタップ
    @objc func sec24Button_tapped(_ sender: UIButton) {
        shotClockView.shotSeconds = 24
        shotClockView.shotClockLabel.text = "24"
    }

    // 14秒セットボタンタップ
    @objc func sec14Button_tapped(_ sender: UIButton) {
        print(123)
        shotClockView.shotSeconds = 14
        shotClockView.shotClockLabel.text = "14"
    }

    func openShotClockTimeOverDialog() {
        AlertDialog.showTimeover(title: "Shot Clock Over", viewController: self) {
            self.shotClockView.controlButton.setTitle("Start", for: .normal)
            self.shotClockView.controlButton.setTitleColor(.limegreen, for: .normal)
            self.shotClockView.shotSeconds = 24
            self.shotClockView.shotClockLabel.text = String(self.shotClockView.shotSeconds)
            self.shotClockView.shotClockStatus = .START
            self.shotClockView.resetButton.isEnabled = false
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
            gameTimeView.gameMinLabel.text = gameTimeMinArray[row]
            setGameSeconds()
            
        } else if component == 1 {
            gameTimeView.gameSecLabel.text = gameTimeSecArray[row]
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
        let min = Int(gameTimeView.gameMinLabel.text!)
        let sec = Int(gameTimeView.gameSecLabel.text!)
        gameTimeView.gameSeconds = min!*60 + sec!
        gameTimeView.oldGameSeconds = gameTimeView.gameSeconds
    }
}

