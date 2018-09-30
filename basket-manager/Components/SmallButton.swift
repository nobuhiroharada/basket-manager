//
//  CustomButton.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/23.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class SmallButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.tintColor = UIColor.darkText
        self.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.backgroundColor = UIColor.groupTableViewBackground
        self.layer.cornerRadius = self.frame.width/2
        
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @objc func touchDown() {
        UIView.animate(withDuration: 0.28, delay: 0.0, animations: {
            self.backgroundColor = UIColor.white
        }, completion: nil)
    }
    
    @objc func touchUpInside() {
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
            self.backgroundColor = UIColor.groupTableViewBackground
        }, completion: nil)
    }
    
}
