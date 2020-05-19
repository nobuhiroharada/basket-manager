//
//  UIViewController+.swift
//  basket-manager
//
//  Created by 原田順啓 on 2020/05/18.
//  Copyright © 2020 Nobuhiro Harada. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func topViewController() -> UIViewController? {
        var vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        
        while vc?.presentedViewController != nil {
            vc = vc?.presentedViewController
        }
        return vc
    }
}
