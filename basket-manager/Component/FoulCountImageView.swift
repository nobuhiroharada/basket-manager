//
//  FounlCountImageView.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/10.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class FoulCountImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        if let image = UIImage(named: "foulcount-inactive") {
            self.image = image
        }
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            initPhoneAttr()
        case .pad:
            initPadAttr()
        default:
            initPhoneAttr()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhoneAttr() {
        
        self.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
    }
    
    func initPadAttr() {
        self.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
    }
}
