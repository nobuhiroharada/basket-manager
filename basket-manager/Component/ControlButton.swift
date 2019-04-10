//
//  ControlButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/23.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ControlButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = .systemFont(ofSize: 18)
        self.bounds = CGRect(x: 0, y: 0, width: 80, height: 30)
        self.setTitleColor(.limegreen, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
