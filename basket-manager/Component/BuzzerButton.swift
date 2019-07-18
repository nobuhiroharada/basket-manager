//
//  BuzzerButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/07/18.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class BuzzerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "buzzer-up"), for: .normal)
        
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
        self.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
    }
    
    func initPadAttr() {
        self.bounds = CGRect(x: 0, y: 0, width: 70, height: 70)
    }
    
}
