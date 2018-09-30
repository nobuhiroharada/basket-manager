//
//  TeamLabel.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/30.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class TeamLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.textAlignment = .center
        self.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        self.font = UIFont.systemFont(ofSize: 13)
        self.isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
}
