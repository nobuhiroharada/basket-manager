//
//  ScoreLabel.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/30.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ScoreLabel: UILabel {
    
    override func awakeFromNib() {
        text = "00"
        textAlignment = .center
        bounds = CGRect(x: 0, y: 0, width: 160, height: 100)
        font = UIFont(name: "DigitalDismay", size: 90)
        textColor = .red
        isUserInteractionEnabled = true
    }
}
