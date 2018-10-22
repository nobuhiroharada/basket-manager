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
        
        tintColor = .darkText
        titleLabel?.font = .boldSystemFont(ofSize: 15)
        bounds = CGRect(x: 0, y: 0, width: 70, height: 30)
        layer.cornerRadius = 15
        
    }
}
