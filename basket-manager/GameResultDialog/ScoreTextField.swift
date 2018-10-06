//
//  ScoreTextField.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/06.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ScoreTextField: UITextField {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.bounds = CGRect(x: 0, y: 0, width: 100, height: 25)
        self.textAlignment = .center
        self.keyboardType = UIKeyboardType.numberPad
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

