//
//  ShotClockView.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ShotClockView: UIView {
    
    var shotClockTimer: Timer!
    var shotSeconds: Int = 24
    var shotClockStatus: ShotClockStatus = .START
    enum ShotClockStatus: String {
        case START
        case STOP
        case RESUME
    }
    
    var shotClockLabel: UILabel
    var controlButton: ControlButton
    var resetButton: ResetButton
    var sec24Button: ShotClockSmallButton
    var sec14Button: ShotClockSmallButton
    
    override init(frame: CGRect) {
        shotClockLabel = UILabel()
        shotClockLabel.text = String(shotSeconds)
        shotClockLabel.textAlignment = .center
        shotClockLabel.bounds = CGRect(x: 0, y: 0, width: 120, height: 80)
        shotClockLabel.font = UIFont(name: "DigitalDismay", size: 100)
        shotClockLabel.textColor = .green
        shotClockLabel.isUserInteractionEnabled = true
        
//        shotClockLabel.backgroundColor = .white
        
        controlButton = ControlButton()
        controlButton.setTitle("Start", for: .normal)
        
//        controlButton.backgroundColor = .blue
        
        resetButton = ResetButton()
        resetButton.isEnabled = false
        
//        resetButton.backgroundColor = .blue
        
        sec24Button = ShotClockSmallButton()
        sec24Button.setTitle("24", for: .normal)
//        sec24Button.backgroundColor = .blue
        
        sec14Button = ShotClockSmallButton()
        sec14Button.setTitle("14", for: .normal)
//        sec14Button.backgroundColor = .blue
        
        super.init(frame: frame)
        
        self.addSubview(shotClockLabel)
        self.addSubview(controlButton)
        self.addSubview(resetButton)
        self.addSubview(sec24Button)
        self.addSubview(sec14Button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func portrait(frame: CGRect) {
        shotClockLabel.center = CGPoint(x: frame.width*(1/2), y: frame.height*(1/2))
        
        controlButton.center = CGPoint(x: frame.width*(1/3), y: frame.height*(7/8))
        
        resetButton.center = CGPoint(x: frame.width*(2/3), y: frame.height*(7/8))
        
        let btnPosX = frame.width*(1/2) + 80
        
        sec24Button.frame = CGRect(x: btnPosX,
                                y: frame.height*(1/2)-40,
                                width: 30, height: 30)
        
        sec14Button.frame = CGRect(x: btnPosX,
                                y: frame.height*(1/2)+10,
                                width: 30, height: 30)
        
    }
    
    func landscape(frame: CGRect) {
        shotClockLabel.center = CGPoint(x: frame.width*(1/2), y: frame.height*(1/2))
        
        let shotClockButtonY = frame.height*(7/8)

        controlButton.center = CGPoint(x: frame.width*(1/2)-50, y: shotClockButtonY)

        resetButton.center = CGPoint(x: frame.width*(1/2)+50, y: shotClockButtonY)

        let secButtonBaseX = frame.width-30

        sec24Button.center = CGPoint(x: secButtonBaseX, y: frame.height*(1/4)+20)
        sec14Button.center = CGPoint(x: secButtonBaseX, y: frame.height*(3/4)-20)
        
    }
}
