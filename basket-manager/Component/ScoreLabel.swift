//
//  ScoreLabel.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/30.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ScoreLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.text = "00"
        self.textAlignment = .center
        self.textColor = .red
        self.isUserInteractionEnabled = true
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            initPhoneAttr()
        case .pad:
            checkOrientation4Pad()
        default:
            initPhoneAttr()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func initPhoneAttr() {
        self.bounds = CGRect(x: 0, y: 0, width: 140, height: 80)
        self.font = UIFont(name: "DigitalDismay", size: 90)
    }
    
    func initPadAttrPortrait() {
        self.bounds = CGRect(x: 0, y: 0, width: 280, height: 160)
        self.font = UIFont(name: "DigitalDismay", size: 180)
    }
    
    func initPadAttrLandscape() {
        self.bounds = CGRect(x: 0, y: 0, width: 360, height: 240)
        self.font = UIFont(name: "DigitalDismay", size: 250)
    }
}
