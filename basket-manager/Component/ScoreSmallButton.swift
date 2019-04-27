//
//  CustomButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/23.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ScoreSmallButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bounds = CGRect(x: 0, y: 0, width: 40, height: 35)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
