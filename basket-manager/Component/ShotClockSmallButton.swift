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
        
        titleLabel?.font = UIFont(name: "DigitalDismay", size: 27)
        tintColor = .white
        bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

