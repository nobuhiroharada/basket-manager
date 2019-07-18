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
    
    var shotClockView: ShotClockView = ShotClockView()
    var gameTimeView: GameTimeView = GameTimeView()
    var scoreView: ScoreView = ScoreView()
    
    var buzzerPlayer: AVAudioPlayer?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gameTimeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shotClockView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        checkOrientation(frame: self.view.frame)
        
        self.view.addSubview(shotClockView)
        self.view.addSubview(gameTimeView)
        self.view.addSubview(scoreView)

        self.view.backgroundColor = UIColor.black
        
        addButtonAction()
        registerGesturerecognizer()

        let buzzerURL = Bundle.main.bundleURL.appendingPathComponent("buzzer.mp3")
        
        do {
            try buzzerPlayer = AVAudioPlayer(contentsOf:buzzerURL)
            
            buzzerPlayer?.prepareToPlay()
            buzzerPlayer?.volume = 2.0
            buzzerPlayer?.delegate = self
            
        } catch {
            print(error)
        }
        
        // 部品の範囲テスト用 Viewの背景変更
//        checkViewArea()
        
//        userdefaults.set(teamLabelA.text, forKey: TEAM_A)
//        userdefaults.set(teamLabelB.text, forKey: TEAM_B)
//        userdefaults.set(Int(scoreLabelA.text ?? "0"),forKey: SCORE_A)
//        userdefaults.set(Int(scoreLabelB.text ?? "0"),forKey: SCORE_B)

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
            
            let shotClockViewLandscapeW: CGFloat = frame.width*(1/3)
            shotClockView.frame = CGRect(x: frame.width*(1/3), y: frame.height*(1/2), width: shotClockViewLandscapeW, height: frame.height*(1/2))

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
        
        shotClockView.buzzerButton.addTarget(self, action: #selector(MainViewController.buzzerButton_tapped), for: .touchUpInside)
        
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
        
        let tapFoulCountA1 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountA1_tapped))
        gameTimeView.foulCountImageA1.addGestureRecognizer(tapFoulCountA1)
        
        let tapFoulCountA2 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountA2_tapped))
        gameTimeView.foulCountImageA2.addGestureRecognizer(tapFoulCountA2)
        
        let tapFoulCountA3 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountA3_tapped))
        gameTimeView.foulCountImageA3.addGestureRecognizer(tapFoulCountA3)
        
        let tapFoulCountA4 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountA4_tapped))
        gameTimeView.foulCountImageA4.addGestureRecognizer(tapFoulCountA4)
        
        let tapFoulCountA5 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountA5_tapped))
        gameTimeView.foulCountImageA5.addGestureRecognizer(tapFoulCountA5)
        
        let tapFoulCountB1 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountB1_tapped))
        gameTimeView.foulCountImageB1.addGestureRecognizer(tapFoulCountB1)
        
        let tapFoulCountB2 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountB2_tapped))
        gameTimeView.foulCountImageB2.addGestureRecognizer(tapFoulCountB2)
        
        let tapFoulCountB3 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountB3_tapped))
        gameTimeView.foulCountImageB3.addGestureRecognizer(tapFoulCountB3)
        
        let tapFoulCountB4 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountB4_tapped))
        gameTimeView.foulCountImageB4.addGestureRecognizer(tapFoulCountB4)
        
        let tapFoulCountB5 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.foulCountB5_tapped))
        gameTimeView.foulCountImageB5.addGestureRecognizer(tapFoulCountB5)
        
    }
    
    func setViews_portrait() {
        self.scoreView.portrait(frame: scoreView.frame)
        self.gameTimeView.portrait(frame: gameTimeView.frame)
        self.shotClockView.portrait(frame: shotClockView.frame)
    }
    
    func setViews_landscape() {
        self.scoreView.landscape(frame: scoreView.frame)
        self.gameTimeView.landscape(frame: gameTimeView.frame)
        self.shotClockView.landscape(frame: shotClockView.frame)
    }
    
    // MARK: - ScoreView
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
    
    @objc func teamLabelA_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showTeamNameEdit(title: "Edit HOME Name", team: TEAM_A, teamLabel: scoreView.teamLabelA, viewController: self)
    }
    
    @objc func teamLabelB_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showTeamNameEdit(title: "Edit GUEST Name", team: TEAM_B, teamLabel: scoreView.teamLabelB, viewController: self)
    }
    
    @objc func scoreLabelA_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showScoreEdit(title: "Edit HOME Score", team: TEAM_A, scoreView: scoreView, viewController: self)
    }
    
    @objc func scoreLabelB_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showScoreEdit(title: "Edit GUEST Score", team: TEAM_B, scoreView: scoreView, viewController: self)
    }
    
    // MARK: - GameTimeView
    // ゲームタイムコントロールボタン押下
    @objc func gameControlButton_tapped(_ sender: UIButton) {

        switch gameTimeView.gameTimerStatus {
            case .START:
                self.runGameTimer()
                gameTimeView.gameControlButton.setImage(UIImage(named: "stop.png"), for: .normal)
                gameTimeView.gameTimerStatus = .STOP
                gameTimeView.toggleGameLabels()
                gameTimeView.picker.isHidden = !gameTimeView.picker.isHidden
                gameTimeView.gameResetButton.isEnabled = true

            case .STOP:
                gameTimeView.gameTimer.invalidate()
                gameTimeView.gameControlButton.setImage(UIImage(named: "start.png"), for: .normal)
                gameTimeView.gameTimerStatus = .RESUME

            case .RESUME:
                self.runGameTimer()
                gameTimeView.gameControlButton.setImage(UIImage(named: "stop.png"), for: .normal)
                gameTimeView.gameTimerStatus = .STOP
        }
    }
    
    // ゲームタイムリセットボタン押下
    @objc func gameResetButton_tapped(_ sender: UIButton) {
        gameTimeView.gameTimer.invalidate()
        gameTimeView.gameSeconds = gameTimeView.oldGameSeconds
        self.showGameTime()
        gameTimeView.gameControlButton.setImage(UIImage(named: "start.png"), for: .normal)
        gameTimeView.gameTimerStatus = .START
        gameTimeView.toggleGameLabels()
        gameTimeView.picker.isHidden = !gameTimeView.picker.isHidden
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
            self.gameTimeView.gameControlButton.setImage(UIImage(named: "start.png"), for: .normal)
            self.gameTimeView.gameTimerStatus = .START
            self.gameTimeView.gameResetButton.isEnabled = false
            self.gameTimeView.toggleGameLabels()
            self.gameTimeView.picker.isHidden = !self.gameTimeView.picker.isHidden
        }

    }
    
    @objc func possessionA_tapped(_ sender: UITapGestureRecognizer) {
        gameTimeView.togglePossession()
    }
    
    @objc func possessionB_tapped(_ sender: UITapGestureRecognizer) {
        gameTimeView.togglePossession()
    }
    
    @objc func foulCountA1_tapped() {
        gameTimeView.tapFoulCountA1()
    }
    
    @objc func foulCountA2_tapped() {
        gameTimeView.tapFoulCountA2()
    }
    
    @objc func foulCountA3_tapped() {
        gameTimeView.tapFoulCountA3()
    }
    
    @objc func foulCountA4_tapped() {
        gameTimeView.tapFoulCountA4()
    }
    
    @objc func foulCountA5_tapped() {
        gameTimeView.tapFoulCountA5()
    }
    
    @objc func foulCountB1_tapped() {
        gameTimeView.tapFoulCountB1()
    }
    
    @objc func foulCountB2_tapped() {
        gameTimeView.tapFoulCountB2()
    }
    
    @objc func foulCountB3_tapped() {
        gameTimeView.tapFoulCountB3()
    }
    
    @objc func foulCountB4_tapped() {
        gameTimeView.tapFoulCountB4()
    }
    
    @objc func foulCountB5_tapped() {
        gameTimeView.tapFoulCountB5()
    }
    
    // MARK: - ShotClockView
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
            shotClockView.controlButton.setImage(UIImage(named: "stop.png"), for: .normal)
            shotClockView.shotClockStatus = .STOP
            shotClockView.resetButton.isEnabled = true

        case .STOP:
            shotClockView.shotClockTimer.invalidate()
            shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
            shotClockView.shotClockStatus = .RESUME

        case .RESUME:
            runShotClockTimer()
            shotClockView.controlButton.setImage(UIImage(named: "stop"), for: .normal)
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
            shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
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
        shotClockView.shotSeconds = 14
        shotClockView.shotClockLabel.text = "14"
    }

    func openShotClockTimeOverDialog() {
        AlertDialog.showTimeover(title: "Shot Clock Over", viewController: self) {
            self.shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
            self.shotClockView.shotSeconds = 24
            self.shotClockView.shotClockLabel.text = String(self.shotClockView.shotSeconds)
            self.shotClockView.shotClockStatus = .START
            self.shotClockView.resetButton.isEnabled = false
        }
    }
    
    @objc func buzzerButton_tapped(_ sender: UIButton) {
        if(buzzerPlayer!.isPlaying) {
            buzzerPlayer?.stop()
            buzzerPlayer?.currentTime = 0
            shotClockView.buzzerButton.setImage(UIImage(named: "buzzer-up"), for: .normal)
        } else {
            buzzerPlayer?.play()
            shotClockView.buzzerButton.setImage(UIImage(named: "buzzer-down"), for: .normal)
        }
    }
    
    // 各部品の範囲(テスト用)
    func checkViewArea() {
        scoreView.backgroundColor = .gray
        scoreView.teamLabelA.backgroundColor = .blue
        scoreView.teamLabelB.backgroundColor = .blue
        scoreView.scoreLabelA.backgroundColor = .blue
        scoreView.scoreLabelB.backgroundColor = .blue
        scoreView.scoreMinusButtonA.backgroundColor = .blue
        scoreView.scorePlusButtonA.backgroundColor = .blue
        scoreView.scoreMinusButtonB.backgroundColor = .blue
        scoreView.scorePlusButtonB.backgroundColor = .blue
        
        shotClockView.backgroundColor = .brown
        shotClockView.shotClockLabel.backgroundColor = .blue
        shotClockView.controlButton.backgroundColor = .blue
        shotClockView.resetButton.backgroundColor = .blue
        shotClockView.sec24Button.backgroundColor = .blue
        shotClockView.sec14Button.backgroundColor = .blue
        
        gameTimeView.backgroundColor = .lightGray
        gameTimeView.gameMinLabel.backgroundColor = .blue
        gameTimeView.gameColonLabel.backgroundColor = .blue
        gameTimeView.gameSecLabel.backgroundColor = .blue
        gameTimeView.gameControlButton.backgroundColor = .blue
        gameTimeView.gameResetButton.backgroundColor = .blue
        gameTimeView.picker.backgroundColor = .blue
    }
}

extension MainViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        shotClockView.buzzerButton.setImage(UIImage(named: "buzzer-up"), for: .normal)
        
    }
    
}
