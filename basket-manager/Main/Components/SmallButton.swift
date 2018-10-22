//
//  CustomButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/23.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class SmallButton: UIButton {
    
    override func awakeFromNib() {
        titleLabel?.font = .boldSystemFont(ofSize: 17)
        tintColor = .darkText
        bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        backgroundColor = .groupTableViewBackground
        layer.cornerRadius = frame.width/2

    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = .white
            } else {
                backgroundColor = .groupTableViewBackground
            }
        }
    }
    
}
