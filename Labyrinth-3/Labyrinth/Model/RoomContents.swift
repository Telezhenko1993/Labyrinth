//
//  RoomContents.swift
//  Labyrinth
//
//  Created by Евгений Тележенко on 29.09.2020.
//  Copyright © 2020 Евгений Тележенко. All rights reserved.
//

import Foundation
import UIKit

class RoomContents: Hashable {

    var name: String
    var count: Int
    var index: Int
    init (name: String, count: Int, index: Int){
        self.name = name
        self.count = count
        self.index = index
    }
    static func ==(lhs: RoomContents, rhs: RoomContents) -> Bool {
        lhs.name == rhs.name
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

class Gold: RoomContents {
    init(){
        super.init(name: "Gold", count: 0, index: 0)
    }
}

class Food: RoomContents {
    init(){
        super.init(name: "Food", count: 0, index: 1)
    }
}

class Torchlight: RoomContents {
    init(){
        super.init(name: "Torchlight", count: 0, index: 2)
        }
    }

class Bone: RoomContents {
    init(){
        super.init(name: "Bone", count: 0, index: 3)
    }
}

class Mushroom: RoomContents {
    init(){
        super.init(name: "Mushroom", count: 0, index: 4)
    }
}

class Stone: RoomContents {
    init() {
        super.init(name: "Stone", count: 0, index: 5)
    }
}

class Chest: RoomContents {
    var isOpened:Bool
    init(){
        self.isOpened = false
        super.init(name: "Chest", count: 0, index: 6)
    }
}

class Key: RoomContents {
    init(){
           super.init(name: "Key", count: 0, index: 7)
       }
}

