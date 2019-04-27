//
//  GameTimeLabel.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/14.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class GameTimeLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textAlignment = .center
        self.textColor = .yellow
        
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
        self.bounds = CGRect(x: 0, y: 0, width: 110, height: 90)
        self.font = UIFont(name: "DigitalDismay", size: 100)
    }
    
    func initPadAttrPortrait() {
        self.bounds = CGRect(x: 0, y: 0, width: 220, height: 180)
        self.font = UIFont(name: "DigitalDismay", size: 200)
    }
    
    func initPadAttrLandscape() {
        self.bounds = CGRect(x: 0, y: 0, width: 300, height: 240)
        self.font = UIFont(name: "DigitalDismay", size: 300)
    }
}
