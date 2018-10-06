//
//  Game.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/05.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import Foundation
import RealmSwift

class Game: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var team_a: String = ""
    @objc dynamic var team_b: String = ""
    @objc dynamic var score_a: Int = 0
    @objc dynamic var score_b: Int = 0
    @objc dynamic var created_at: Date?
    @objc dynamic var played_at: Date?
}
