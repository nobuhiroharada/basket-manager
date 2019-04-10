//
//  ShotClockSmallButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/04.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ShotClockSmallButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .white
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            initPhoneAttr()
        case .pad:
            initPadAttr()
        default:
            initPhoneAttr()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhoneAttr() {

        bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        titleLabel?.font = UIFont(name: "DigitalDismay", size: 27)
    }
    
    func initPadAttr() {
        bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        titleLabel?.font = UIFont(name: "DigitalDismay", size: 54)
    }
}

