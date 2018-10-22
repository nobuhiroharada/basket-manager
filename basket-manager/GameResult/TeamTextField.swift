//
//  TeamTextField.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/06.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class TeamTextField: UITextField {
    
    override func awakeFromNib() {
        bounds = CGRect(x: 0, y: 0, width: 100, height: 25)
        textAlignment = .center
    }
}
