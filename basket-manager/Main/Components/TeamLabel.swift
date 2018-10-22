//
//  TeamLabel.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/30.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class TeamLabel: UILabel {
    
    override func awakeFromNib() {
        font = .boldSystemFont(ofSize: 20)
        textColor = .white
        textAlignment = .center
        bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        isUserInteractionEnabled = true
    }
    
}
