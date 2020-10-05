//
//  Room.swift
//  Labyrinth
//
//  Created by Евгений Тележенко on 12.04.2020.
//  Copyright © 2020 Евгений Тележенко. All rights reserved.
//

import Foundation



struct Room {
    
    var coordinate: Point
    
// Двери ввел словарем. Установить дверь, создать - можно просто изменив значение для ключа.
    var doors: [String : Bool] = ["North": false, "South" : false, "East" : false, "West": false]
    
// Содержимое комнаты
    var contents: [RoomContents] = [Gold(), Food(),  Torchlight(), Bone(),  Mushroom(), Stone (),  Key(),Chest()]

// Показатель соединенности с остальными комнатами. Нужен будет для генерации лабиринта.    
    var isConnected: Bool = false
    
    
// Показатель темной комнаты. Если комната темная, в ней нет фонаря и его нет в ранце - будет высвечиваться сообщение
    var isDark: Bool = false

    // Переменная, нужная для случайной генерации двери.    
    var possibleDirections: [String : Bool] = ["North": true, "South" : true, "East" : true, "West": true]
    var possibleDirectionsInString: [String] = []
    
// Функция, необходимая для заполнение комнат случайными вещами.
    mutating func generateRandomObject() {
        
        let randomGenerator = Int.random(in: 0...5)
        switch randomGenerator {
            
        case 1,2,3,4,5:
                contents[randomGenerator].count += 1
        case 0:

                contents[randomGenerator].count += Int.random(in: 10...30)
            
        default:
            print("Проблемы с созданием предмета")
        }
    }
    
    mutating func generateObjects() {
        let quantityRandomizer = Int.random(in: 1...6)
        var counter = 0
        repeat {
            generateRandomObject()
            counter += 1
        } while counter < quantityRandomizer
        
    }
    
}
