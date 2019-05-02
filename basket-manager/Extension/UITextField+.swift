//
//  UITextField.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/06.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
