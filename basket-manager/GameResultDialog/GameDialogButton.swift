//
//  GameDialogButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/06.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class GameDialogButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.tintColor = UIColor.darkText
        self.bounds = CGRect(x: 0, y: 0, width: 100, height: 60)
//        self.layer.cornerRadius = self.frame.width/2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
