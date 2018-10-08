//
//  ScoreLabel.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/30.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ScoreLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.text = "00"
        self.textAlignment = .center
        self.bounds = CGRect(x: 0, y: 0, width: 140, height: 90)
        self.font = UIFont.boldSystemFont(ofSize: 70)
        self.isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
}
