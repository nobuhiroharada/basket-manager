//
//  ScoreShowDialogViewController.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/30.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

class GameResultDialogViewController: UIViewController {

    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teamANameLabel: UILabel!
    @IBOutlet weak var teamBNameLabel: UILabel!
    @IBOutlet weak var scoreALabel: UILabel!
    @IBOutlet weak var scoreBLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var teamAString: String?
    var teamBString: String?
    var scoreAString: String?
    var scoreBString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.bounds = CGRect(x: 0, y: 0, width: 250, height: 250)
        dialogView.center = CGPoint(x: self.view.frame.width*(1/2),
                                    y: self.view.frame.height*(1/2))
        
        titleLabel.text = "試合結果"
        titleLabel.bounds = CGRect(x: 0, y: 0, width: dialogView.frame.width, height: 50)
        titleLabel.textAlignment = .center
        
        teamANameLabel.text = teamAString
        teamANameLabel.bounds = CGRect(x: 0, y: 0, width: dialogView.frame.width*(1/2), height: 50)
        teamANameLabel.center = CGPoint(x: dialogView.frame.width*(1/4),
                                        y: 50)
        teamANameLabel.textAlignment = .center
        
        teamBNameLabel.text = teamBString
        teamBNameLabel.bounds = CGRect(x: 0, y: 0, width: dialogView.frame.width*(1/2), height: 50)
        teamBNameLabel.center = CGPoint(x: dialogView.frame.width*(3/4),
                                        y: 50)
        teamBNameLabel.textAlignment = .center
        
        scoreALabel.text = scoreAString
        scoreALabel.bounds = CGRect(x: 0, y: 0, width: dialogView.frame.width*(1/2), height: 50)
        scoreALabel.center = CGPoint(x: dialogView.frame.width*(1/4),
                                        y: 100)
        scoreALabel.textAlignment = .center
        
        scoreBLabel.text = scoreBString
        scoreBLabel.bounds = CGRect(x: 0, y: 0, width: dialogView.frame.width*(1/2), height: 50)
        scoreBLabel.center = CGPoint(x: dialogView.frame.width*(3/4),
                                     y: 100)
        scoreBLabel.textAlignment = .center
        
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        
        dateLabel.text = f.string(from: now)
        dateLabel.bounds = CGRect(x: 0, y: 0, width: dialogView.frame.width*(1/2), height: 50)
        dateLabel.center = CGPoint(x: dialogView.frame.width*(3/4),
                                     y: 150)
        dateLabel.textAlignment = .center
        
        cancelBtn.setTitle("キャンセル", for: .normal)
        cancelBtn.tintColor = UIColor.darkText
        
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.tintColor = UIColor.darkText
    }

    @IBAction func tapCancelBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
