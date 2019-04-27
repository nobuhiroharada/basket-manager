//
//  GameTime.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class GameTimeView: UIView {
    
    // 試合時間ラベル
    var gameTimer: Timer!
    var gameSeconds = 600
    var oldGameSeconds = 600
    var gameTimerStatus: GameTimerStatus = .START
    enum GameTimerStatus: String {
        case START
        case STOP
        case RESUME
    }
    
    var gameMinLabel: GameTimeLabel
    var gameSecLabel: GameTimeLabel
    var gameColonLabel: GameTimeLabel
    var gameControlButton: ControlButton
    var gameResetButton: ResetButton
    
    // 試合時間ピッカー
    var minArray: [String] = []
    var secArray: [String] = []
    var picker: UIPickerView
    var pickerMinLabel: UILabel
    var pickerSecLabel: UILabel
    
    // ポゼッション
    var possessionImageA: PossesionImageView
    var possessionImageB: PossesionImageView
    var isPossessionA = true
    
    // チームファウルカウント
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
        gameMinLabel = GameTimeLabel()
        gameMinLabel.text = "10"
        
        gameColonLabel = GameTimeLabel()
        gameColonLabel.text = ":"
        
        gameSecLabel = GameTimeLabel()
        gameSecLabel.text = "00"
        
        gameSeconds = Int(gameMinLabel.text!)!*60
        gameSeconds += Int(gameSecLabel.text!)!
        
        // GameTime ピッカー
        for i in 0...20 { //分設定(ゲームタイムピッカー用)
            minArray.append(String(format: "%02d", i))
        }
        
        for i in 0..<60 { //秒設定(ゲームタイムピッカー用)
            secArray.append(String(format: "%02d", i))
        }
        
        picker = UIPickerView(frame: CGRect.zero)
        
        picker.setValue(UIColor.white, forKey: "textColor")

        pickerMinLabel = UILabel()
        pickerMinLabel.text = "min"
        pickerMinLabel.textColor = .yellow
        pickerMinLabel.sizeToFit()

        picker.addSubview(pickerMinLabel)

        pickerSecLabel = UILabel()
        pickerSecLabel.text = "sec"
        pickerSecLabel.textColor = .yellow
        pickerSecLabel.sizeToFit()

        picker.addSubview(pickerSecLabel)

        // 試合時間 ボタン
        gameControlButton = ControlButton()
        gameResetButton = ResetButton()
        gameResetButton.isEnabled = false
        
        // ポゼッション ボタン
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
        
        picker.delegate = self
        picker.dataSource = self
        
        picker.selectRow(10, inComponent: 0, animated: true)
        picker.selectRow(0, inComponent: 1, animated: true)
        
        toggleGameLabels()
        
        self.addSubview(gameMinLabel)
        self.addSubview(gameColonLabel)
        self.addSubview(gameSecLabel)
        self.addSubview(gameControlButton)
        self.addSubview(gameResetButton)
        self.addSubview(gameControlButton)
        self.addSubview(picker)
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
    
    func checkCurrentDevice() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            checkOrientation4Phone()
        case .pad:
            checkOrientation4Pad()
        default:
            checkOrientation4Phone()
        }
    }
    
    func checkOrientation4Phone() {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            initPhoneAttr()
            
        case .landscapeLeft, .landscapeRight:
            initPhoneAttr()
            picker.center = CGPoint(x: frame.width/2, y: frame.height/2)
            
        default:
            initPhoneAttr()
        }
    }
    
    func checkOrientation4Pad() {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            initPadAttrPortrait()
            
        case .landscapeLeft, .landscapeRight:
            initPadAttrLandscape()
            
        default:
            initPadAttrPortrait()
        }
    }
    
    func portrait(frame: CGRect) {
        
        checkCurrentDevice()
        
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
        
        pickerMinLabel.frame = CGRect(x: picker.bounds.width*0.4 - pickerMinLabel.bounds.width/2,
                                              y: picker.bounds.height/2 - (pickerMinLabel.bounds.height/2),
                                              width: pickerMinLabel.bounds.width,
                                              height: pickerMinLabel.bounds.height)
        
        pickerSecLabel.frame = CGRect(x: picker.bounds.width*0.9 - pickerSecLabel.bounds.width/2,
                                              y: picker.bounds.height/2 - (pickerSecLabel.bounds.height/2),
                                              width: pickerSecLabel.bounds.width,
                                              height: pickerSecLabel.bounds.height)
        
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
        
        checkCurrentDevice()
        
        let gameLabelY = frame.height*(1/2)
        
        gameMinLabel.center = CGPoint(x: frame.width*(1/3)-20,
                                      y: gameLabelY)
        
        gameColonLabel.center = CGPoint(x: frame.width*(1/2),
                                        y: gameLabelY)
        
        gameSecLabel.center = CGPoint(x: frame.width*(2/3)+20,
                                      y: gameLabelY)
        
        pickerMinLabel.frame = CGRect(x: picker.bounds.width*0.4 - picker.bounds.width/2,
                                              y: picker.bounds.height/2 - (pickerMinLabel.bounds.height/2),
                                              width: pickerMinLabel.bounds.width,
                                              height: pickerMinLabel.bounds.height)
        
        pickerSecLabel.frame = CGRect(x: picker.bounds.width*0.9 - pickerSecLabel.bounds.width/2,
                                              y: picker.bounds.height/2 - (pickerSecLabel.bounds.height/2),
                                              width: pickerSecLabel.bounds.width,
                                              height: pickerSecLabel.bounds.height)
        
        let possessionImageY = frame.height*(1/2)
        
        possessionImageA.center = CGPoint(x: frame.width*(1/16),
                                          y: possessionImageY)
        
        possessionImageB.center = CGPoint(x: frame.width*(15/16),
                                          y: possessionImageY)
        
        let gameTimeButtonY = frame.height*(7/8)
        
        gameControlButton.center = CGPoint(x: frame.width*(3/8), y: gameTimeButtonY)
        
        gameResetButton.center = CGPoint(x: frame.width*(5/8), y: gameTimeButtonY)
        
        
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

        gameMinLabel.initPhoneAttr()

        gameColonLabel.bounds = CGRect(x: 0, y: 0, width: 30, height: 100)
        gameColonLabel.font = UIFont(name: "DigitalDismay", size: 100)

        gameSecLabel.initPhoneAttr()

        picker.frame = CGRect(x: frame.width*0.2, y: 0, width: frame.width*0.6, height: 100)
    }
    
    func initPadAttrPortrait() {
        gameMinLabel.initPadAttrPortrait()
        
        gameColonLabel.bounds = CGRect(x: 0, y: 0, width: 60, height: 200)
        gameColonLabel.font = UIFont(name: "DigitalDismay", size: 200)
        
        gameSecLabel.initPadAttrPortrait()
        
        picker.frame = CGRect(x: frame.width*0.2, y: 0, width: frame.width*0.6, height: 200)
    }
    
    func initPadAttrLandscape() {
        gameMinLabel.initPadAttrLandscape()
        
        gameColonLabel.bounds = CGRect(x: 0, y: 0, width: 90, height: 240)
        gameColonLabel.font = UIFont(name: "DigitalDismay", size: 300)
        
        gameSecLabel.initPadAttrLandscape()
        
        picker.frame = CGRect(x: frame.width*0.2, y: 0, width: frame.width*0.6, height: 200)
        picker.center = CGPoint(x: frame.width/2, y: frame.height/2)
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

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension GameTimeView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minArray.count
        }
        
        return secArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return minArray[row]
        }
        
        return secArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            gameMinLabel.text = minArray[row]
            setGameSeconds()
            
        } else if component == 1 {
            gameSecLabel.text = secArray[row]
            setGameSeconds()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .yellow
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            initPickerLabel4Phone(label)
        case .pad:
            initPickerLabel4Pad(label)
        default:
            initPickerLabel4Phone(label)
        }
        
        if component == 0 {
            label.text = minArray[row]
        } else if component == 1 {
            label.text = secArray[row]
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 30
        case .pad:
            return 88
        default:
            return 30
        }
    }
    
    func initPickerLabel4Phone(_ label: UILabel) {
        
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70)
        
        label.font =  UIFont(name: "DigitalDismay", size: 30)
    }
    
    func initPickerLabel4Pad(_ label: UILabel) {
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 140)
        
        label.font =  UIFont(name: "DigitalDismay", size: 100)
    }
    
    func setGameSeconds() {
        let min = Int(gameMinLabel.text!)
        let sec = Int(gameSecLabel.text!)
        gameSeconds = min!*60 + sec!
        oldGameSeconds = gameSeconds
    }
}
