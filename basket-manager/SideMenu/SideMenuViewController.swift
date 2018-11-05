//
//  SideMenuViewController.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/19.
//  Copyright © 2018 Nobuhiro Harada. All rights reserved.
//

import UIKit
import RealmSwift

class SideMenuViewController: UIViewController {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var timerBtn: SideMenuButton!
    @IBOutlet weak var historyBtn: SideMenuButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var lineView2: UIView!
    
    let userdefaults = UserDefaults.standard
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.darkGray
        
        let statusBar = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        statusBar.backgroundColor = statusBarColor
        self.view.addSubview(statusBar)
        
        versionLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String

        versionLabel.center = CGPoint(x: 90, y: self.view.frame.height-30)
        
        baseView.frame = CGRect(x: 0, y: 0, width: 200, height: self.view.frame.height)
        baseView.backgroundColor = UIColor.darkGray
        
        let statsuBarHeight = UIApplication.shared.statusBarFrame.height
        
        timerBtn.frame = CGRect(x: 0, y: statsuBarHeight, width: 180, height: 75)
        historyBtn.frame = CGRect(x: 0, y: statsuBarHeight+75, width: 180, height: 75)
        
        lineView1.frame = CGRect(x: 0, y: statsuBarHeight+75, width: 300, height: 0.5)
        lineView2.frame = CGRect(x: 0, y: statsuBarHeight+150, width: 300, height: 0.5)
    }

}
