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
    var startGameTime = Date()
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
    
    var possessionImageA: UIImageView
    var possessionImageB: UIImageView
    var isPossessionA = true
    
    override init(frame: CGRect) {
        
        // GameTime ラベル
        gameMinLabel = UILabel()
        gameMinLabel.text = "10"
        gameMinLabel.textAlignment = .center
        gameMinLabel.bounds = CGRect(x: 0, y: 0, width: 110, height: 90)
        gameMinLabel.textColor = .yellow
        gameMinLabel.font = UIFont(name: "DigitalDismay", size: 100)
//        gameMinLabel.backgroundColor = .blue
        
        gameColonLabel = UILabel()
        gameColonLabel.text = ":"
        gameColonLabel.textAlignment = .center
        gameColonLabel.bounds = CGRect(x: 0, y: 0, width: 30, height: 100)
        gameColonLabel.font = UIFont(name: "DigitalDismay", size: 100)
        gameColonLabel.textColor = .yellow
//        gameColonLabel.backgroundColor = .blue
        
        gameSecLabel = UILabel()
        gameSecLabel.text = "00"
        gameSecLabel.textAlignment = .center
        gameSecLabel.bounds = CGRect(x: 0, y: 0, width: 110, height: 90)
        gameSecLabel.font = UIFont(name: "DigitalDismay", size: 100)
        gameSecLabel.textColor = .yellow
//        gameSecLabel.backgroundColor = .blue
        
        gameSeconds = Int(gameMinLabel.text!)!*60
        gameSeconds += Int(gameSecLabel.text!)!
        
        // GameTime ボタン
        gameControlButton = ControlButton()
        gameControlButton.setTitle("Start", for: .normal)
        gameControlButton.setTitleColor(.limegreen, for: .normal)
//        gameControlButton.backgroundColor = .blue
        
        gameResetButton = ResetButton()
        gameResetButton.isEnabled = false
//        gameResetButton.backgroundColor = .blue
        
        possessionImageA = UIImageView()
        possessionImageA.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        possessionImageA.isUserInteractionEnabled = true
        if let imageA = UIImage(named: "posses-a-active") {
            possessionImageA.image = imageA
        }
        
        possessionImageB = UIImageView()
        possessionImageB.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        possessionImageB.isUserInteractionEnabled = true
        if let imageB = UIImage(named: "posses-b-inactive") {
            possessionImageB.image = imageB
        }
        
        super.init(frame: frame)
        
        toggleGameLabels()
        
        self.addSubview(gameMinLabel)
        self.addSubview(gameColonLabel)
        self.addSubview(gameSecLabel)
        self.addSubview(gameControlButton)
        self.addSubview(gameResetButton)
        self.addSubview(gameControlButton)
        self.addSubview(possessionImageA)
        self.addSubview(possessionImageB)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func portrait(frame: CGRect) {
        
        let gameLabelY = frame.height*(1/2)
        
        gameMinLabel.center = CGPoint(x: frame.width*(1/3)-10,
                                      y: gameLabelY)
        
        gameColonLabel.center = CGPoint(x: frame.width*(1/2),
                                        y: gameLabelY)
        
        gameSecLabel.center = CGPoint(x: frame.width*(2/3)+10,
                                      y: gameLabelY)
        
        let gameButtonY = frame.height*(7/8)
        
        gameControlButton.center = CGPoint(x: frame.width*(1/3), y: gameButtonY)
        
        gameResetButton.center = CGPoint(x: frame.width*(2/3), y: gameButtonY)
        
        
        possessionImageA.center = CGPoint(x: frame.width*(1/8),
                                          y: gameButtonY)
        
        possessionImageB.center = CGPoint(x: frame.width*(7/8),
                                          y: gameButtonY)
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
    }
    
    func toggleGameLabels() {
        gameMinLabel.isHidden = !gameMinLabel.isHidden
        gameColonLabel.isHidden = !gameColonLabel.isHidden
        gameSecLabel.isHidden = !gameSecLabel.isHidden
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
//extension GameTimeView: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 {
//            return gameTimeMinArray.count
//        }
//
//        return gameTimeSecArray.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0 {
//            return gameTimeMinArray[row]
//        }
//
//        return gameTimeSecArray[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if component == 0 {
//            gameMinLabel.text = gameTimeMinArray[row]
//            setGameSeconds()
//
//        } else if component == 1 {
//            gameSecLabel.text = gameTimeSecArray[row]
//            setGameSeconds()
//        }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70))
//        label.textAlignment = .center
//        label.textColor = .yellow
//        label.font =  UIFont(name: "DigitalDismay", size: 30)
//
//        if component == 0 {
//            label.text = gameTimeMinArray[row]
//        } else if component == 1 {
//            label.text = gameTimeSecArray[row]
//        }
//        print(label.text)
//        return label
//    }
//
//    func setGameSeconds() {
//        let min = Int(self.gameMinLabel.text!)
//        let sec = Int(self.gameSecLabel.text!)
//        self.gameSeconds = min!*60 + sec!
//        self.oldGameSeconds = gameSeconds
//    }
//}
