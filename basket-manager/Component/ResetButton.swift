//
//  ResetButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/23.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ResetButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitle("Reset", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 18)
        self.bounds = CGRect(x: 0, y: 0, width: 80, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
