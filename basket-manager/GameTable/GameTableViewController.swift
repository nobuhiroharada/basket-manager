//
//  GameListViewController.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/05.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit
import RealmSwift

class GameTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gameCountLabel: UILabel!
    
    let realm = try! Realm()
    var games: Results<Game>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTableView()
        
        self.tableView.register(UINib(nibName: "GameTableCell", bundle: nil), forCellReuseIdentifier: "GameTableCell")
        
        tableView.rowHeight = 60
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func loadTableView() {
        games = realm.objects(Game.self).sorted(byKeyPath: "played_at", ascending: false)
        tableView.reloadData()
    }
    
    @IBAction func tapBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        
//        cell.delegate = self
        
        if let game = games?[indexPath.row] {
            let index = indexPath.row + 1
            cell.indexLabel?.text = String(index)
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

// MARK: - GameTableReloadDelegate
extension GameTableViewController: GameTableReloadDelegate {
    func gameTableViewReload() {
        tableView.reloadData()
    }
}
