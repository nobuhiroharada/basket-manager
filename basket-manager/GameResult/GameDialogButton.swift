//
//  GameDialogButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/06.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class GameDialogButton: UIButton {
    
    override func awakeFromNib() {
        titleLabel?.font = .boldSystemFont(ofSize: 17)
        tintColor = .darkText
        bounds = CGRect(x: 0, y: 0, width: 100, height: 60)
    }
}
