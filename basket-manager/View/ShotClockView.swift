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
    
    var shotClockLabel: ShotClockLabel
    var controlButton: ControlButton
    var resetButton: ResetButton
    var sec24Button: ShotClockSmallButton
    var sec14Button: ShotClockSmallButton
    
    override init(frame: CGRect) {
        shotClockLabel = ShotClockLabel()
        
        controlButton = ControlButton()
        controlButton.setTitle("Start", for: .normal)
        
        resetButton = ResetButton()
        resetButton.isEnabled = false
        
        sec24Button = ShotClockSmallButton()
        sec24Button.setTitle("24", for: .normal)
        
        sec14Button = ShotClockSmallButton()
        sec14Button.setTitle("14", for: .normal)
        
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
        
        let btnPosX = frame.width - frame.width*(1/4)
        
        sec24Button.center = CGPoint(x: btnPosX, y: frame.height*(1/4)+20)
        sec14Button.center = CGPoint(x: btnPosX, y: frame.height*(3/4)-20)
    }
    
    func landscape(frame: CGRect) {
        shotClockLabel.center = CGPoint(x: frame.width*(1/2), y: frame.height*(1/2))
        
        let shotClockButtonY = frame.height*(7/8)

        controlButton.center = CGPoint(x: frame.width*(1/4), y: shotClockButtonY)

        resetButton.center = CGPoint(x: frame.width*(3/4), y: shotClockButtonY)

        let secButtonBaseX = frame.width - frame.width*(1/4)

        sec24Button.center = CGPoint(x: secButtonBaseX, y: frame.height*(1/4)+20)
        sec14Button.center = CGPoint(x: secButtonBaseX, y: frame.height*(3/4)-20)
        
    }
}
