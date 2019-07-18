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
    
    class func showShotClockEdit(title: String, shotClockView: ShotClockView, viewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    if textField.text != "" {
                        shotClockView.shotClockLabel.text = textField.text
                        shotClockView.shotSeconds = Int(textField.text!)!
                    }
                }
            }
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = String(0)
            textField.text = shotClockView.shotClockLabel.text
            textField.keyboardType = UIKeyboardType.numberPad
        })
        viewController.present(alert, animated: true, completion: nil)
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
    
    class func showScoreEdit(title: String, team: String, scoreView: ScoreView, viewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    
                    if let textFieldText = textField.text {
                        if !textFieldText.isEmpty {
                            if team == TEAM_A {
                                scoreView.scoreLabelA.text = textField.text
                                scoreView.scoreA = Int(textFieldText)!
                                userdefaults.set(textField.text, forKey: TEAM_A)
                            }
                            else if team == TEAM_B {
                                scoreView.scoreLabelB.text = textField.text
                                scoreView.scoreB = Int(textFieldText)!
                                userdefaults.set(textField.text, forKey: TEAM_B)
                            }
                        }
                    }
                    
                }
            }
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = String(0)
            if team == TEAM_A {
                textField.text = scoreView.scoreLabelA.text
            }
            else if team == TEAM_B {
                textField.text = scoreView.scoreLabelB.text
            }
            
            textField.keyboardType = UIKeyboardType.numberPad
        })
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showBuzzerSettingActionSheet(viewController: UIViewController) {
        
        let actionSheet: UIAlertController = UIAlertController(title: "buzzer_title".localized,  message: "buzzer_subtitle".localized, preferredStyle:  UIAlertController.Style.actionSheet)
        
        var yesAction = UIAlertAction(title: "buzzer_yes".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            userdefaults.set(true, forKey: BUZEER_AUTO_BEEP)
            
        })
        
        var noAction = UIAlertAction(title: "buzzer_no".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            userdefaults.set(false, forKey: BUZEER_AUTO_BEEP)
            
        })
        
        let cancelAction = UIAlertAction(title: "buzzer_cancel".localized, style: UIAlertAction.Style.cancel, handler: nil)
        
        if userdefaults.bool(forKey: BUZEER_AUTO_BEEP) {
            yesAction = selectAlertController(action: yesAction)
        } else {
            noAction = selectAlertController(action: noAction)
        }
        
        actionSheet.addAction(yesAction)
        actionSheet.addAction(noAction)
        actionSheet.addAction(cancelAction)
        
        actionSheet.popoverPresentationController?.sourceView = viewController.view
        
        let screenSize = UIScreen.main.bounds
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    static func selectAlertController(action: UIAlertAction) -> UIAlertAction {
        
        action.setValue(UIImage(named: "checkmark.png")?.scaleImage(scaleSize: 0.4), forKey: "image")
        action.setValue(UIColor.red, forKey: "imageTintColor")
        action.setValue(UIColor.red, forKey: "titleTextColor")
        
        return action
    }
    
}
