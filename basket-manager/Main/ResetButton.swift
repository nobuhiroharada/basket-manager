//
//  ResetButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/23.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ResetButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.setTitle("リセット", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.tintColor = UIColor.darkText
        self.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.layer.cornerRadius = self.frame.width/2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
}
