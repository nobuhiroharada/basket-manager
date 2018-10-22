//
//  GameListViewController.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/05.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class GameTableViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gameCountLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    let realm = try! Realm()
    var games: Results<Game>?
    
    let statusBar = UIView(frame: UIApplication.shared.statusBarFrame)
    let displaySize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.frame = CGRect(x: 0, y: statusBar.frame.height, width: displaySize.width, height: navigationBar.frame.height)
        
        gameCountLabel.frame = CGRect(x: displaySize.width-100, y: statusBar.frame.height, width: 100, height: navigationBar.frame.height)
        guard let aa = UINib(nibName: "GameTableCell", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        aa.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.tableView.register(UINib(nibName: "GameTableCell", bundle: nil), forCellReuseIdentifier: "GameTableCell")
        
        tableView.rowHeight = 60
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadTableView()
        
        backBtn.target = self.revealViewController()
        backBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //  SideMenu表示用スワイプ
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController()?.rearViewRevealWidth = 180
    }

    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0,
                                 y: statusBar.frame.height+navigationBar.frame.height,
                                 width: displaySize.width,
                                 height: displaySize.height-statusBar.frame.height+navigationBar.frame.height)
    }
    
    func loadTableView() {
        games = realm.objects(Game.self).sorted(byKeyPath: "played_at", ascending: false)
        tableView.reloadData()
    }
    
    func delete(at indexPath: IndexPath) {
        if let gameForDeletion = games?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(gameForDeletion)
                }
            } catch {
                print("Error deleting game, \(error)")
            }
        }
    }
    
}

// MARK: - Table View Delegate, Datasource Methods
extension GameTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let gameCount = games?.count {
            if gameCount == 1 {
                gameCountLabel.text = String(gameCount) + " game"
            } else {
                gameCountLabel.text = String(gameCount) + " games"
            }
        }
        return games?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableCell", for: indexPath) as! GameTableCell
        
        cell.delegate = self
        
        if let game = games?[indexPath.row] {
            cell.teamALabel?.text = game.team_a
            cell.teamBLabel?.text = game.team_b
            cell.scoreALabel?.text = String(game.score_a)
            cell.scoreBLabel?.text = String(game.score_b)
            cell.idLabel.text = String(game.id)
            let f = DateFormatter().getFormat()
            if let updatedAt = game.played_at {
                let date = f.string(from: updatedAt)
                cell.gameDataLabel?.text = date
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toGameResultDialog", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {

            let gameResultDialog = segue.destination as! GameResultDialogViewController
            
            gameResultDialog.status = "update"
            gameResultDialog.game = games?[indexPath.row]
            gameResultDialog.delegate = self
        }
    }
}

// MARK: - SwipeTableViewCellDelegate
extension GameTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.delete(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
}

// MARK: - GameTableReloadDelegate
extension GameTableViewController: GameTableReloadDelegate {
    func gameTableViewReload() {
        tableView.reloadData()
    }
}
