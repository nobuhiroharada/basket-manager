//
//  ControlButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/23.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ControlButton: UIButton {
    
    override func awakeFromNib() {
        
        titleLabel?.font = .systemFont(ofSize: 18)
        bounds = CGRect(x: 0, y: 0, width: 80, height: 30)
        tintColor = .limegreen
    }
}
