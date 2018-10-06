//
//  ScoreShowDialogViewController.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/30.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit
import RealmSwift

class GameResultDialogViewController: UIViewController {

    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var teamATextField: TeamTextField!
    @IBOutlet weak var teamBTextField: TeamTextField!
    @IBOutlet weak var scoreATextField: UITextField!
    @IBOutlet weak var scoreBTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelBtn: GameDialogButton!
    @IBOutlet weak var saveBtn: GameDialogButton!
    
    var teamAString: String?
    var teamBString: String?
    var scoreAString: String?
    var scoreBString: String?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.bounds = CGRect(x: 0, y: 0, width: 250, height: 250)
        dialogView.center = CGPoint(x: self.view.frame.width*(1/2),
                                    y: self.view.frame.height*(1/2))
        dialogView.layer.cornerRadius = 10
        
        titleLabel.text = "試合結果"
        titleLabel.bounds = CGRect(x: 0, y: 0, width: dialogView.frame.width, height: 50)
        titleLabel.textAlignment = .center
        
        teamATextField.text = teamAString
        teamATextField.center = CGPoint(x: dialogView.frame.width*(1/4),
                                        y: 50)
        teamATextField.delegate = self
        
        teamBTextField.text = teamBString
        teamBTextField.center = CGPoint(x: dialogView.frame.width*(3/4),
                                        y: 50)
        teamBTextField.delegate = self
        
        scoreATextField.text = scoreAString
        scoreATextField.center = CGPoint(x: dialogView.frame.width*(1/4),
                                        y: 100)
        scoreATextField.textAlignment = .center
        scoreATextField.tag = 3
        scoreATextField.delegate = self
        
        
        scoreBTextField.text = scoreBString
        scoreBTextField.center = CGPoint(x: dialogView.frame.width*(3/4),
                                     y: 100)
        scoreBTextField.textAlignment = .center
        scoreATextField.tag = 4
        scoreBTextField.delegate = self
        
        datePicker.date = Date()
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.frame = CGRect(x: 0, y: 0, width: dialogView.frame.width-20, height: 50)
        datePicker.center = CGPoint(x: dialogView.frame.width*(1/2),
                                   y: 150)
        
        cancelBtn.setTitle("キャンセル", for: .normal)
        cancelBtn.center = CGPoint(x: dialogView.frame.width*(1/4),
                                         y: 220)
        
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.center = CGPoint(x: dialogView.frame.width*(3/4),
                                   y: 220)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        teamATextField.becomeFirstResponder()
        self.configureObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.removeObserver()
    }
    
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // キーボードが出てくると、ダイアログも上がる
    @objc func keyboardWillShow(notification: Notification?) {
        
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -100)
            self.view.transform = transform
            
        })
    }
    
    // キーボードが消えると、ダイアログも下がる
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    @IBAction func tapSaveBtn(_ sender: UIButton) {
        let newGame = Game()
        newGame.id = self.getNewId()
        newGame.team_a = teamATextField.text!
        newGame.team_b = teamBTextField.text!
        newGame.score_a = Int(scoreATextField.text!)!
        newGame.score_b = Int(scoreBTextField.text!)!
        newGame.created_at = Date()
        newGame.played_at = datePicker.date
        print(datePicker.date)
        do {
            try realm.write {
                realm.add(newGame)
            }
            
        } catch {
            print("Error saving todo \(error)")
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func tapCancelBtn(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func getNewId() -> Int {
        var gameCount = realm.objects(Game.self).count
        gameCount += 1
        return gameCount
    }
}

extension GameResultDialogViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 3 || textField.tag == 4 {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 3
        }
        
        return true
    }
}
