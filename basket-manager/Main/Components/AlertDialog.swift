//
//  AlertDialog.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/05.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import Foundation
import UIKit

class AlertDialog: UIAlertController {
    
    class func showTimeover(title: String, viewController: UIViewController, callback: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: callback)
    }
    
    class func showTeamNameEdit(title: String, team: String, teamLabel: TeamLabel, viewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    teamLabel.text = textField.text
                    if team == TEAM_A {
                        userdefaults.set(textField.text, forKey: TEAM_A)
                    }
                    else if team == TEAM_B {
                        userdefaults.set(textField.text, forKey: TEAM_B)
                    }
                }
            }
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "TEAM NAME"
            textField.text = teamLabel.text
        })
        viewController.present(alert, animated: true, completion: nil)
    }
    
//    class func showScoreEdit(title: String, team: String, scoreLabel: ScoreLabel, score: Int, viewController: UIViewController) {
//        
//        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
//            if let textFields = alert.textFields {
//                
//                for textField in textFields {
//                    scoreLabel.text = textField.text
//                    score = Int(textField.text!)!
//                    
//                    if team == TEAM_A {
//                        userdefaults.set(textField.text, forKey: TEAM_A)
//                    }
//                    else if team == TEAM_B {
//                        userdefaults.set(textField.text, forKey: TEAM_B)
//                    }
//                }
//            }
//        }
//        
//        alert.addAction(okAction)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        
//        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
//            textField.placeholder = String(0)
//            textField.text = scoreLabel.text
//            textField.keyboardType = UIKeyboardType.numberPad
//        })
//        viewController.present(alert, animated: true, completion: nil)
//    }
}
