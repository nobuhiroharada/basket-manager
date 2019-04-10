//
//  ShotClockLabel.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/08.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ShotClockLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.text = "24"
        self.textAlignment = .center
        self.textColor = .green
        self.isUserInteractionEnabled = true
        
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
        self.bounds = CGRect(x: 0, y: 0, width: 120, height: 80)
        self.font = UIFont(name: "DigitalDismay", size: 100)
    }
    
    func initPadAttr() {
        self.bounds = CGRect(x: 0, y: 0, width: 240, height: 160)
        self.font = UIFont(name: "DigitalDismay", size: 200)
    }
}
