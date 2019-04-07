//
//  PossesLabel.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/06.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class PossesImage: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        isUserInteractionEnabled = true
    }
}
