//
//  AllinPageView.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/27.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class AllinPageView: UIView {
    
    var shotClockView: ShotClockView
    var gameTimeView: GameTimeView
    var scoreView: ScoreView
    
    override init(frame: CGRect) {
        
        shotClockView = ShotClockView(frame: frame)
        gameTimeView = GameTimeView(frame: frame)
        scoreView = ScoreView(frame: frame)
        
        super.init(frame: frame)
        
        scoreView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gameTimeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shotClockView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(shotClockView)
        self.addSubview(gameTimeView)
        self.addSubview(scoreView)
        
//        print(shotClockView.shotClockStatus)
//        addButtonAction()
//        registerGesturerecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewPortrait(frame: CGRect) {
        checkOrientation(frame: frame)
        self.scoreView.portrait(frame: scoreView.frame)
        self.gameTimeView.portrait4AllinPage(frame: gameTimeView.frame)
        self.shotClockView.portrait4AllinPage(frame: shotClockView.frame)
    }
    
    func setViewLandscape() {
        self.scoreView.landscape(frame: scoreView.frame)
        self.gameTimeView.landscape4AllinPage(frame: gameTimeView.frame)
        self.shotClockView.landscape4AllinPage(frame: shotClockView.frame)
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
            
            self.bringSubviewToFront(shotClockView)
            
            gameTimeView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*(1/2))
            
            
            scoreView.frame = CGRect(x: 0, y: frame.height*(1/2), width: frame.width, height: frame.height*(1/2))
            
        default:
            shotClockView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*(1/3))
            
            gameTimeView.frame = CGRect(x: 0, y: frame.height*(1/3), width: frame.width, height: frame.height*(1/3))
            
            scoreView.frame = CGRect(x: 0, y: frame.height*(2/3), width: frame.width, height: frame.height*(1/3))
        }
    }
    
    func addButtonAction() {
        scoreView.scoreMinusButtonA.addTarget(self, action: #selector(AllinPageView.scoreMinusButtonA_touched), for: .touchUpInside)
        
        scoreView.scorePlusButtonA.addTarget(self, action: #selector(AllinPageView.scorePlusButtonA_touched), for: .touchUpInside)
        
        scoreView.scoreMinusButtonB.addTarget(self, action: #selector(AllinPageView.scoreMinusButtonB_touched), for: .touchUpInside)
        
        scoreView.scorePlusButtonB.addTarget(self, action: #selector(AllinPageView.scorePlusButtonB_touched), for: .touchUpInside)
        
//        shotClockView.sec24Button.addTarget(self, action: #selector(AllinPageView.sec24Button_tapped), for: .touchUpInside)
//
//        shotClockView.sec14Button.addTarget(self, action: #selector(AllinPageView.sec14Button_tapped), for: .touchUpInside)
//
//        shotClockView.controlButton.addTarget(self, action: #selector(AllinPageView.shotClockControlButton_tapped), for: .touchUpInside)
//
//        shotClockView.resetButton.addTarget(self, action: #selector(AllinPageView.shotClockResetButton_tapped), for: .touchUpInside)
        
//        gameTimeView.gameControlButton.addTarget(self, action: #selector(AllinPageView.gameControlButton_tapped), for: .touchUpInside)
//
//        gameTimeView.gameResetButton.addTarget(self, action: #selector(AllinPageView.gameResetButton_tapped), for: .touchUpInside)
    }
    
    func registerGesturerecognizer() {
        let tapTeamA = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.teamLabelA_tapped))
        scoreView.teamLabelA.addGestureRecognizer(tapTeamA)
        
        let tapTeamB = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.teamLabelB_tapped))
        scoreView.teamLabelB.addGestureRecognizer(tapTeamB)
        
        let tapScoreA = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.scoreLabelA_tapped))
        scoreView.scoreLabelA.addGestureRecognizer(tapScoreA)
        
        let tapScoreB = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.scoreLabelB_tapped))
        scoreView.scoreLabelB.addGestureRecognizer(tapScoreB)
        
//        let tapShotClock = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.shotClockLabel_tapped))
//        shotClockView.shotClockLabel.addGestureRecognizer(tapShotClock)
        
//        let tapPossessionA = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.possessionA_tapped))
//        gameTimeView.possessionImageA.addGestureRecognizer(tapPossessionA)
//
//        let tapPossessionB = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.possessionB_tapped))
//        gameTimeView.possessionImageB.addGestureRecognizer(tapPossessionB)
//
//        let tapFoulCountA1 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountA1_tapped))
//        gameTimeView.foulCountImageA1.addGestureRecognizer(tapFoulCountA1)
//
//        let tapFoulCountA2 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountA2_tapped))
//        gameTimeView.foulCountImageA2.addGestureRecognizer(tapFoulCountA2)
//
//        let tapFoulCountA3 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountA3_tapped))
//        gameTimeView.foulCountImageA3.addGestureRecognizer(tapFoulCountA3)
//
//        let tapFoulCountA4 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountA4_tapped))
//        gameTimeView.foulCountImageA4.addGestureRecognizer(tapFoulCountA4)
//
//        let tapFoulCountA5 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountA5_tapped))
//        gameTimeView.foulCountImageA5.addGestureRecognizer(tapFoulCountA5)
//
//        let tapFoulCountB1 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountB1_tapped))
//        gameTimeView.foulCountImageB1.addGestureRecognizer(tapFoulCountB1)
//
//        let tapFoulCountB2 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountB2_tapped))
//        gameTimeView.foulCountImageB2.addGestureRecognizer(tapFoulCountB2)
//
//        let tapFoulCountB3 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountB3_tapped))
//        gameTimeView.foulCountImageB3.addGestureRecognizer(tapFoulCountB3)
//
//        let tapFoulCountB4 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountB4_tapped))
//        gameTimeView.foulCountImageB4.addGestureRecognizer(tapFoulCountB4)
//
//        let tapFoulCountB5 = UITapGestureRecognizer(target: self, action: #selector(AllinPageView.foulCountB5_tapped))
//        gameTimeView.foulCountImageB5.addGestureRecognizer(tapFoulCountB5)
//
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
        AlertDialog.showTeamNameEdit(title: "Edit HOME Name", team: TEAM_A, teamLabel: scoreView.teamLabelA, viewController: mainViewController)
    }
    
    @objc func teamLabelB_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showTeamNameEdit(title: "Edit GUEST Name", team: TEAM_B, teamLabel: scoreView.teamLabelB, viewController: mainViewController)
    }
    
    @objc func scoreLabelA_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showScoreEdit(title: "Edit HOME Score", team: TEAM_A, scoreView: scoreView, viewController: mainViewController)
    }
    
    @objc func scoreLabelB_tapped(_ sender: UITapGestureRecognizer) {
        AlertDialog.showScoreEdit(title: "Edit GUEST Score", team: TEAM_B, scoreView: scoreView, viewController: mainViewController)
    }
    
    // MARK: - GameTimeView
    // ゲームタイムコントロールボタン押下
//    @objc func gameControlButton_tapped(_ sender: UIButton) {
//        
//        switch gameTimeView.gameTimerStatus {
//        case .START:
//            self.runGameTimer()
//            gameTimeView.gameControlButton.setImage(UIImage(named: "stop.png"), for: .normal)
//            gameTimeView.gameTimerStatus = .STOP
//            gameTimeView.toggleGameLabels()
//            gameTimeView.picker.isHidden = !gameTimeView.picker.isHidden
//            gameTimeView.gameResetButton.isEnabled = true
//            
//        case .STOP:
//            gameTimeView.gameTimer.invalidate()
//            gameTimeView.gameControlButton.setImage(UIImage(named: "start.png"), for: .normal)
//            gameTimeView.gameTimerStatus = .RESUME
//            
//        case .RESUME:
//            self.runGameTimer()
//            gameTimeView.gameControlButton.setImage(UIImage(named: "stop.png"), for: .normal)
//            gameTimeView.gameTimerStatus = .STOP
//        }
//    }
//    
//    // ゲームタイムリセットボタン押下
//    @objc func gameResetButton_tapped(_ sender: UIButton) {
//        gameTimeView.gameTimer.invalidate()
//        gameTimeView.gameSeconds = gameTimeView.oldGameSeconds
//        self.showGameTime()
//        gameTimeView.gameControlButton.setImage(UIImage(named: "start.png"), for: .normal)
//        gameTimeView.gameTimerStatus = .START
//        gameTimeView.toggleGameLabels()
//        gameTimeView.picker.isHidden = !gameTimeView.picker.isHidden
//        gameTimeView.gameResetButton.isEnabled = false
//    }
//    
//    func runGameTimer(){
//        gameTimeView.gameTimer = Timer.scheduledTimer(
//            timeInterval: 1,
//            target: self,
//            selector: #selector(self.gameTimerCount),
//            userInfo: nil,
//            repeats: true)
//    }
//    
//    @objc func gameTimerCount() {
//        if gameTimeView.gameSeconds < 1 {
//            gameTimeView.gameTimer.invalidate()
//            gameTimeView.gameSecLabel.text = "00"
//            self.openGameTimeOverDialog()
//        } else {
//            gameTimeView.gameSeconds -= 1
//            self.showGameTime()
//        }
//    }
//    
//    func showGameTime() {
//        let min = gameTimeView.gameSeconds/60
//        let sec = gameTimeView.gameSeconds%60
//        gameTimeView.gameMinLabel.text = String(format: "%02d", min)
//        gameTimeView.gameSecLabel.text = String(format: "%02d", sec)
//    }
//    
//    func openGameTimeOverDialog() {
//        AlertDialog.showTimeover(title: "Game Time Over", viewController: mainViewController) {
//            self.gameTimeView.gameTimer.invalidate()
//            self.gameTimeView.gameSeconds = self.gameTimeView.oldGameSeconds
//            self.showGameTime()
//            self.gameTimeView.gameControlButton.setImage(UIImage(named: "start.png"), for: .normal)
//            self.gameTimeView.gameTimerStatus = .START
//            self.gameTimeView.gameResetButton.isEnabled = false
//            self.gameTimeView.toggleGameLabels()
//            self.gameTimeView.picker.isHidden = !self.gameTimeView.picker.isHidden
//        }
//        
//    }
    
//    @objc func possessionA_tapped(_ sender: UITapGestureRecognizer) {
//        gameTimeView.togglePossession()
//    }
//
//    @objc func possessionB_tapped(_ sender: UITapGestureRecognizer) {
//        gameTimeView.togglePossession()
//    }
//
//    @objc func foulCountA1_tapped() {
//        gameTimeView.tapFoulCountA1()
//    }
//
//    @objc func foulCountA2_tapped() {
//        gameTimeView.tapFoulCountA2()
//    }
//
//    @objc func foulCountA3_tapped() {
//        gameTimeView.tapFoulCountA3()
//    }
//
//    @objc func foulCountA4_tapped() {
//        gameTimeView.tapFoulCountA4()
//    }
//
//    @objc func foulCountA5_tapped() {
//        gameTimeView.tapFoulCountA5()
//    }
//
//    @objc func foulCountB1_tapped() {
//        gameTimeView.tapFoulCountB1()
//    }
//
//    @objc func foulCountB2_tapped() {
//        gameTimeView.tapFoulCountB2()
//    }
//
//    @objc func foulCountB3_tapped() {
//        gameTimeView.tapFoulCountB3()
//    }
//
//    @objc func foulCountB4_tapped() {
//        gameTimeView.tapFoulCountB4()
//    }
//
//    @objc func foulCountB5_tapped() {
//        gameTimeView.tapFoulCountB5()
//    }
    
    // MARK: - ShotClockView
//    @objc func shotClockLabel_tapped() {
//
//        if shotClockView.shotClockStatus == .STOP {
//            shotClockView.shotClockTimer.invalidate()
//        }
//
//        AlertDialog.showShotClockEdit(title: "Edit Timer", shotClockView: shotClockView, viewController: mainViewController)
//
//    }
//
//    // ショットクロックコントロールボタンタップ
//    @objc func shotClockControlButton_tapped(_ sender: UIButton) {
//        print(shotClockView.shotClockStatus)
//        switch shotClockView.shotClockStatus {
//        case .START:
//            print("ppp")
//            shotClockView.runShotClockTimer()
//            shotClockView.controlButton.setImage(UIImage(named: "stop.png"), for: .normal)
//            shotClockView.shotClockStatus = .STOP
//            shotClockView.resetButton.isEnabled = true
//
//        case .STOP:
//            print("rr")
//            shotClockView.shotClockTimer.invalidate()
//            shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
//            shotClockView.shotClockStatus = .RESUME
//
//        case .RESUME:
//            shotClockView.runShotClockTimer()
//            shotClockView.controlButton.setImage(UIImage(named: "stop"), for: .normal)
//            shotClockView.shotClockStatus = .STOP
//        }
//    }
//
//    func runShotClockTimer(){
//        shotClockView.shotClockTimer = Timer.scheduledTimer(
//            timeInterval: 1,
//            target: self,
//            selector: #selector(shotClockView.shotClockCount),
//            userInfo: nil,
//            repeats: true)
//    }
//
//    @objc func shotClockCount() {
//        if shotClockView.shotSeconds < 1 {
//            shotClockView.shotClockTimer.invalidate()
//            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
//            openShotClockTimeOverDialog()
//        } else {
//            shotClockView.shotSeconds -= 1
//            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
//        }
//    }
//
//    // ショットクロックリセットボタンタップ
//    @objc func shotClockResetButton_tapped(_ sender: UIButton) {
//        switch shotClockView.shotClockStatus {
//        case .START:
//            return
//        case .STOP:
//            shotClockView.shotSeconds = 24
//            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
//        case .RESUME:
//            shotClockView.shotClockTimer.invalidate()
//            shotClockView.shotSeconds = 24
//            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
//            shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
//            shotClockView.shotClockStatus = .START
//
//            shotClockView.resetButton.isEnabled = false
//        }
//    }
//
//    // 24秒セットボタンタップ
//    @objc func sec24Button_tapped(_ sender: UIButton) {
//        shotClockView.shotSeconds = 24
//        shotClockView.shotClockLabel.text = "24"
//    }
//
//    // 14秒セットボタンタップ
//    @objc func sec14Button_tapped(_ sender: UIButton) {
//        shotClockView.shotSeconds = 14
//        shotClockView.shotClockLabel.text = "14"
//    }
//
//    func openShotClockTimeOverDialog() {
//        AlertDialog.showTimeover(title: "Shot Clock Over", viewController: mainViewController) {
//            self.shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
//            self.shotClockView.shotSeconds = 24
//            self.shotClockView.shotClockLabel.text = String(self.shotClockView.shotSeconds)
//            self.shotClockView.shotClockStatus = .START
//            self.shotClockView.resetButton.isEnabled = false
//        }
//    }
}
