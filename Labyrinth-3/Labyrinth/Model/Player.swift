//
//  Player.swift
//  Labyrinth
//
//  Created by Евгений Тележенко on 12.04.2020.
//  Copyright © 2020 Евгений Тележенко. All rights reserved.
//

import Foundation

enum WalkDirections {
    case up
    case down
    case left
    case right
}


class Player {
    
    var backpack: [RoomContents]
    var steps: Int?
    var atRoom: Room?
    var isWin: Bool? 
    init(backpack: [RoomContents]){
        self.backpack = backpack
    }
}
