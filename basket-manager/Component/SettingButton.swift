//
//  SettingButton.swift
//  basket-manager
//
//  Created by 原田順啓 on 2020/05/18.
//  Copyright © 2020 Nobuhiro Harada. All rights reserved.
//

import UIKit

class SettingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "setting"), for: .normal)
        
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

