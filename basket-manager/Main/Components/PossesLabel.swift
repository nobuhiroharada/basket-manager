//
//  PossesLabel.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/06.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class PossesLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.textAlignment = .center
        self.textColor = UIColor.red
        self.font = UIFont.systemFont(ofSize: 20)
        self.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
}
