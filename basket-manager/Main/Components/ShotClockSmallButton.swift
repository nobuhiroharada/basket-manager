//
//  ShotClockSmallButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/04.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ShotClockSmallButton: UIButton {
    
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: "DigitalDismay", size: 27)
        tintColor = .white
        bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
    }
    
}

