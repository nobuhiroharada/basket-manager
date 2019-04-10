//
//  GameTime.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class GameTimeView: UIView {
    
    var gameTimer: Timer!
    var gameSeconds = 600
    var oldGameSeconds = 600
    var gameTimerStatus: GameTimerStatus = .START
    enum GameTimerStatus: String {
        case START
        case STOP
        case RESUME
    }
    
    var gameMinLabel: UILabel
    var gameSecLabel: UILabel
    var gameColonLabel: UILabel
    var gameControlButton: ControlButton
    var gameResetButton: ResetButton
    
    var possessionImageA: PossesionImageView
    var possessionImageB: PossesionImageView
    var isPossessionA = true
    
    var foulCountImageA1: FoulCountImageView
    var foulCountImageA2: FoulCountImageView
    var foulCountImageA3: FoulCountImageView
    var foulCountImageA4: FoulCountImageView
    var foulCountImageA5: FoulCountImageView
    
    var foulCountImageB1: FoulCountImageView
    var foulCountImageB2: FoulCountImageView
    var foulCountImageB3: FoulCountImageView
    var foulCountImageB4: FoulCountImageView
    var foulCountImageB5: FoulCountImageView
    
    var isFirstFoulA: Bool = true
    var isFirstFoulB: Bool = true
    
    override init(frame: CGRect) {
        
        // GameTime ラベル
        gameMinLabel = UILabel()
        gameMinLabel.text = "10"
        gameMinLabel.textAlignment = .center
        
        gameMinLabel.textColor = .yellow
        
        
        gameColonLabel = UILabel()
        gameColonLabel.text = ":"
        gameColonLabel.textAlignment = .center
        gameColonLabel.textColor = .yellow
        
        gameSecLabel = UILabel()
        gameSecLabel.text = "00"
        gameSecLabel.textAlignment = .center
        gameSecLabel.textColor = .yellow
        
        gameSeconds = Int(gameMinLabel.text!)!*60
        gameSeconds += Int(gameSecLabel.text!)!
        
        // GameTime ボタン
        gameControlButton = ControlButton()
        gameControlButton.setTitle("Start", for: .normal)
        gameControlButton.setTitleColor(.limegreen, for: .normal)
        
        gameResetButton = ResetButton()
        gameResetButton.isEnabled = false
        
        possessionImageA = PossesionImageView(frame: CGRect.zero)
        if let imageA = UIImage(named: "posses-a-active") {
            possessionImageA.image = imageA
        }
        
        possessionImageB = PossesionImageView(frame: CGRect.zero)
        if let imageB = UIImage(named: "posses-b-inactive") {
            possessionImageB.image = imageB
        }
        
        foulCountImageA1 = FoulCountImageView(frame: CGRect.zero)
        foulCountImageA2 = FoulCountImageView(frame: CGRect.zero)
        foulCountImageA3 = FoulCountImageView(frame: CGRect.zero)
        foulCountImageA4 = FoulCountImageView(frame: CGRect.zero)
        foulCountImageA5 = FoulCountImageView(frame: CGRect.zero)
        
        foulCountImageB1 = FoulCountImageView(frame: CGRect.zero)
        foulCountImageB2 = FoulCountImageView(frame: CGRect.zero)
        foulCountImageB3 = FoulCountImageView(frame: CGRect.zero)
        foulCountImageB4 = FoulCountImageView(frame: CGRect.zero)
        foulCountImageB5 = FoulCountImageView(frame: CGRect.zero)
        
        super.init(frame: frame)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            initPhoneAttr()
        case .pad:
            initPadAttr()
        default:
            initPhoneAttr()
        }
        
        toggleGameLabels()
        
        self.addSubview(gameMinLabel)
        self.addSubview(gameColonLabel)
        self.addSubview(gameSecLabel)
        self.addSubview(gameControlButton)
        self.addSubview(gameResetButton)
        self.addSubview(gameControlButton)
        self.addSubview(possessionImageA)
        self.addSubview(possessionImageB)
        self.addSubview(foulCountImageA1)
        self.addSubview(foulCountImageA2)
        self.addSubview(foulCountImageA3)
        self.addSubview(foulCountImageA4)
        self.addSubview(foulCountImageA5)
        self.addSubview(foulCountImageB1)
        self.addSubview(foulCountImageB2)
        self.addSubview(foulCountImageB3)
        self.addSubview(foulCountImageB4)
        self.addSubview(foulCountImageB5)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func portrait(frame: CGRect) {
        
        let gameLabelY = frame.height*(1/4)
        
        gameMinLabel.center = CGPoint(x: frame.width*(1/3)-10,
                                      y: gameLabelY)
        
        gameColonLabel.center = CGPoint(x: frame.width*(1/2),
                                        y: gameLabelY)
        
        gameSecLabel.center = CGPoint(x: frame.width*(2/3)+10,
                                      y: gameLabelY)
        
        let gameButtonY = frame.height*(5/8)
        
        gameControlButton.center = CGPoint(x: frame.width*(1/3), y: gameButtonY)
        
        gameResetButton.center = CGPoint(x: frame.width*(2/3), y: gameButtonY)
        
        
        possessionImageA.center = CGPoint(x: frame.width*(1/8),
                                          y: gameButtonY)
        
        possessionImageB.center = CGPoint(x: frame.width*(7/8),
                                          y: gameButtonY)
        
        let founlCountY = frame.height*(7/8)
        foulCountImageA1.center = CGPoint(x: frame.width*(1/12), y: founlCountY)
        foulCountImageA2.center = CGPoint(x: frame.width*(2/12), y: founlCountY)
        foulCountImageA3.center = CGPoint(x: frame.width*(3/12), y: founlCountY)
        foulCountImageA4.center = CGPoint(x: frame.width*(4/12), y: founlCountY)
        foulCountImageA5.center = CGPoint(x: frame.width*(5/12), y: founlCountY)
        
        foulCountImageB1.center = CGPoint(x: frame.width*(7/12), y: founlCountY)
        foulCountImageB2.center = CGPoint(x: frame.width*(8/12), y: founlCountY)
        foulCountImageB3.center = CGPoint(x: frame.width*(9/12), y: founlCountY)
        foulCountImageB4.center = CGPoint(x: frame.width*(10/12), y: founlCountY)
        foulCountImageB5.center = CGPoint(x: frame.width*(11/12), y: founlCountY)
    }
    
    func landscape(frame: CGRect) {
        
        let gameLabelY = frame.height*(1/2)
        
        gameMinLabel.center = CGPoint(x: frame.width*(3/8),
                                      y: gameLabelY)
        
        gameColonLabel.center = CGPoint(x: frame.width*(1/2),
                                        y: gameLabelY)
        
        gameSecLabel.center = CGPoint(x: frame.width*(5/8),
                                      y: gameLabelY)
        
        let gameTimeButtonY = frame.height*(7/8)
        
        gameControlButton.center = CGPoint(x: frame.width*(3/8), y: gameTimeButtonY)
        
        gameResetButton.center = CGPoint(x: frame.width*(5/8), y: gameTimeButtonY)
        
        
        possessionImageA.center = CGPoint(x: frame.width*(1/8),
                                          y: gameLabelY)
        
        possessionImageB.center = CGPoint(x: frame.width*(7/8),
                                          y: gameLabelY)
        
        foulCountImageA1.center = CGPoint(x: frame.width*(1/24), y: gameTimeButtonY)
        foulCountImageA2.center = CGPoint(x: frame.width*(2/24), y: gameTimeButtonY)
        foulCountImageA3.center = CGPoint(x: frame.width*(3/24), y: gameTimeButtonY)
        foulCountImageA4.center = CGPoint(x: frame.width*(4/24), y: gameTimeButtonY)
        foulCountImageA5.center = CGPoint(x: frame.width*(5/24), y: gameTimeButtonY)
        
        foulCountImageB1.center = CGPoint(x: frame.width*(19/24), y: gameTimeButtonY)
        foulCountImageB2.center = CGPoint(x: frame.width*(20/24), y: gameTimeButtonY)
        foulCountImageB3.center = CGPoint(x: frame.width*(21/24), y: gameTimeButtonY)
        foulCountImageB4.center = CGPoint(x: frame.width*(22/24), y: gameTimeButtonY)
        foulCountImageB5.center = CGPoint(x: frame.width*(23/24), y: gameTimeButtonY)
    }
    
    func initPhoneAttr() {
        gameMinLabel.bounds = CGRect(x: 0, y: 0, width: 110, height: 90)
        gameMinLabel.font = UIFont(name: "DigitalDismay", size: 100)
        
        gameColonLabel.bounds = CGRect(x: 0, y: 0, width: 30, height: 100)
        gameColonLabel.font = UIFont(name: "DigitalDismay", size: 100)
        
        gameSecLabel.bounds = CGRect(x: 0, y: 0, width: 110, height: 90)
        gameSecLabel.font = UIFont(name: "DigitalDismay", size: 100)
    }
    
    func initPadAttr() {
        gameMinLabel.bounds = CGRect(x: 0, y: 0, width: 220, height: 180)
        gameMinLabel.font = UIFont(name: "DigitalDismay", size: 200)
        
        gameColonLabel.bounds = CGRect(x: 0, y: 0, width: 60, height: 200)
        gameColonLabel.font = UIFont(name: "DigitalDismay", size: 200)
        
        gameSecLabel.bounds = CGRect(x: 0, y: 0, width: 220, height: 180)
        gameSecLabel.font = UIFont(name: "DigitalDismay", size: 200)
    }
    
    func toggleGameLabels() {
        gameMinLabel.isHidden = !gameMinLabel.isHidden
        gameColonLabel.isHidden = !gameColonLabel.isHidden
        gameSecLabel.isHidden = !gameSecLabel.isHidden
    }
    
    func togglePossession() {
        if isPossessionA {
            possessionImageA.image = UIImage(named: "posses-a-inactive")
            possessionImageB.image = UIImage(named: "posses-b-active")
        } else {
            possessionImageA.image = UIImage(named: "posses-a-active")
            possessionImageB.image = UIImage(named: "posses-b-inactive")
        }
        
        isPossessionA = !isPossessionA
    }
    
    func tapFoulCountA1() {
        if isFirstFoulA {
            foulCountImageA1.image = UIImage(named: "foulcount-active")
            isFirstFoulA = !isFirstFoulA
        } else {
            foulCountImageA1.image = UIImage(named: "foulcount-inactive")
            isFirstFoulA = !isFirstFoulA
        }
        
        foulCountImageA2.image = UIImage(named: "foulcount-inactive")
        foulCountImageA3.image = UIImage(named: "foulcount-inactive")
        foulCountImageA4.image = UIImage(named: "foulcount-inactive")
        foulCountImageA5.image = UIImage(named: "foulcount-inactive")
    }
    
    func tapFoulCountA2() {
        foulCountImageA1.image = UIImage(named: "foulcount-active")
        foulCountImageA2.image = UIImage(named: "foulcount-active")
        foulCountImageA3.image = UIImage(named: "foulcount-inactive")
        foulCountImageA4.image = UIImage(named: "foulcount-inactive")
        foulCountImageA5.image = UIImage(named: "foulcount-inactive")
        isFirstFoulA = false
    }
    
    func tapFoulCountA3() {
        foulCountImageA1.image = UIImage(named: "foulcount-active")
        foulCountImageA2.image = UIImage(named: "foulcount-active")
        foulCountImageA3.image = UIImage(named: "foulcount-active")
        foulCountImageA4.image = UIImage(named: "foulcount-inactive")
        foulCountImageA5.image = UIImage(named: "foulcount-inactive")
        isFirstFoulA = false
    }
    
    func tapFoulCountA4() {
        foulCountImageA1.image = UIImage(named: "foulcount-active")
        foulCountImageA2.image = UIImage(named: "foulcount-active")
        foulCountImageA3.image = UIImage(named: "foulcount-active")
        foulCountImageA4.image = UIImage(named: "foulcount-active")
        foulCountImageA5.image = UIImage(named: "foulcount-inactive")
        isFirstFoulA = false
    }
    
    func tapFoulCountA5() {
        foulCountImageA1.image = UIImage(named: "foulcount-five")
        foulCountImageA2.image = UIImage(named: "foulcount-five")
        foulCountImageA3.image = UIImage(named: "foulcount-five")
        foulCountImageA4.image = UIImage(named: "foulcount-five")
        foulCountImageA5.image = UIImage(named: "foulcount-five")
        isFirstFoulA = false
    }
    
    func tapFoulCountB1() {
        if isFirstFoulB {
            foulCountImageB1.image = UIImage(named: "foulcount-active")
            isFirstFoulB = !isFirstFoulB
        } else {
            foulCountImageB1.image = UIImage(named: "foulcount-inactive")
            isFirstFoulB = !isFirstFoulB
        }
        
        foulCountImageB2.image = UIImage(named: "foulcount-inactive")
        foulCountImageB3.image = UIImage(named: "foulcount-inactive")
        foulCountImageB4.image = UIImage(named: "foulcount-inactive")
        foulCountImageB5.image = UIImage(named: "foulcount-inactive")
    }
    
    func tapFoulCountB2() {
        foulCountImageB1.image = UIImage(named: "foulcount-active")
        foulCountImageB2.image = UIImage(named: "foulcount-active")
        foulCountImageB3.image = UIImage(named: "foulcount-inactive")
        foulCountImageB4.image = UIImage(named: "foulcount-inactive")
        foulCountImageB5.image = UIImage(named: "foulcount-inactive")
        isFirstFoulB = false
    }
    
    func tapFoulCountB3() {
        foulCountImageB1.image = UIImage(named: "foulcount-active")
        foulCountImageB2.image = UIImage(named: "foulcount-active")
        foulCountImageB3.image = UIImage(named: "foulcount-active")
        foulCountImageB4.image = UIImage(named: "foulcount-inactive")
        foulCountImageB5.image = UIImage(named: "foulcount-inactive")
        isFirstFoulB = false
    }
    
    func tapFoulCountB4() {
        foulCountImageB1.image = UIImage(named: "foulcount-active")
        foulCountImageB2.image = UIImage(named: "foulcount-active")
        foulCountImageB3.image = UIImage(named: "foulcount-active")
        foulCountImageB4.image = UIImage(named: "foulcount-active")
        foulCountImageB5.image = UIImage(named: "foulcount-inactive")
        isFirstFoulB = false
    }
    
    func tapFoulCountB5() {
        foulCountImageB1.image = UIImage(named: "foulcount-five")
        foulCountImageB2.image = UIImage(named: "foulcount-five")
        foulCountImageB3.image = UIImage(named: "foulcount-five")
        foulCountImageB4.image = UIImage(named: "foulcount-five")
        foulCountImageB5.image = UIImage(named: "foulcount-five")
        isFirstFoulB = false
    }
}
