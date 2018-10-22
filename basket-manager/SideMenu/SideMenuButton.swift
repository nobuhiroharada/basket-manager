//
//  SideMenuButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/20.
//  Copyright © 2018 Nobuhiro Harada. All rights reserved.
//

import UIKit

class SideMenuButton: UIButton {

    override func awakeFromNib() {
        titleLabel?.font = .boldSystemFont(ofSize: 30)
        titleLabel?.textAlignment = .center
        tintColor = .white
    }
    
}
