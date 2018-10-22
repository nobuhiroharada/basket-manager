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
    @IBOutlet weak var shareBtn: SideMenuButton!
    @IBOutlet weak var saveBtn: SideMenuButton!
    @IBOutlet weak var historyBtn: SideMenuButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var lineView3: UIView!
    @IBOutlet weak var lineView4: UIView!
    
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
        shareBtn.frame = CGRect(x: 0, y: statsuBarHeight+75, width: 180, height: 75)
        saveBtn.frame = CGRect(x: 0, y: statsuBarHeight+150, width: 180, height: 75)
        historyBtn.frame = CGRect(x: 0, y: statsuBarHeight+225, width: 180, height: 75)
        
        lineView1.frame = CGRect(x: 0, y: statsuBarHeight+75, width: 300, height: 0.5)
        lineView2.frame = CGRect(x: 0, y: statsuBarHeight+150, width: 300, height: 0.5)
        lineView3.frame = CGRect(x: 0, y: statsuBarHeight+225, width: 300, height: 0.5)
        lineView4.frame = CGRect(x: 0, y: statsuBarHeight+300, width: 300, height: 0.5)
    }
    
    
    @IBAction func tapSaveBtn(_ sender: UIButton) {
        let newGame = Game()
        newGame.id = self.getNewId()
        newGame.team_a = userdefaults.string(forKey: "team_a") ?? "HOME"
        newGame.team_b = userdefaults.string(forKey: "team_b") ?? "GUEST"
        newGame.score_a = userdefaults.integer(forKey: "score_a")
        newGame.score_b = userdefaults.integer(forKey: "score_b")
        newGame.created_at = Date()
        newGame.played_at = Date()
        do {
            try realm.write {
                realm.add(newGame)
            }
            saveSuccessAlert()
        } catch {
            saveErrorAlert()
        }
    }
    
    func getNewId() -> Int {
        var gameCount = realm.objects(Game.self).count
        gameCount += 1
        return gameCount
    }
    
    func saveSuccessAlert() {
        let alert = UIAlertController(title: "Game Result", message: "Save Success", preferredStyle:  UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveErrorAlert() {
        let alert = UIAlertController(title: "Game Result", message: "Save Error", preferredStyle:  UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapShareBtn(_ sender: UIButton) {
        
        let teamA  = userdefaults.string(forKey: "team_a") ?? "HOME"
        let teamB  = userdefaults.string(forKey: "team_b") ?? "GUEST"
        let scoreA = userdefaults.integer(forKey: "score_a")
        let scoreB = userdefaults.integer(forKey: "score_b")
        
        let shareText = "\(teamA) vs \(teamB) ： \(scoreA) - \(scoreB) "
        
        let activityItems = [shareText]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
    }

}
