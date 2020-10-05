//
//  field.swift
//  Labyrinth
//
//  Created by Евгений Тележенко on 12.04.2020.
//  Copyright © 2020 Евгений Тележенко. All rights reserved.
//


import Foundation


// Структура игрового поля. по факту, содержит все элементы. Поэтому инициализация довольно объемная.
struct Field {
    
    var rooms: [Room] = []
   
    var width: Int
    var length: Int
    
   var player = Player(backpack: [Gold(), Food(),  Torchlight(), Bone(),  Mushroom(), Stone (),  Key(),Chest()])
    
    init (width: Int, length: Int){
        self.length = length
        self.width = width
    
        
        
// Создание массива комнат        
        for y in 0...(length - 1) {
            for x in 0...(width - 1){
                rooms.append(Room(coordinate:Point(x: x, y: y)))
            }
        }
        
        player.steps = 2 * (length * width)
        player.atRoom = rooms[Int.random(in: 0...(rooms.count - 1) )]
        
// Создание ключа и сундука
        
        let randomForChest = Int.random(in: 0...rooms.count - 1)
        rooms[randomForChest].contents[6].count = 1
        
        let randomForKey = Int.random(in: 0...rooms.count - 1)
        rooms[randomForKey].contents[7].count = 1
        
// Ограничение по координатам (замкнутость лабиринта)
        
        var checkCounter = 0
        repeat {
            
            if rooms[checkCounter].coordinate.x == 0 {
                rooms[checkCounter].possibleDirections["West"] = false
            }
            if rooms[checkCounter].coordinate.x == width - 1 {
                rooms[checkCounter].possibleDirections["East"] = false
            }
            if rooms[checkCounter].coordinate.y == 0 {
                rooms[checkCounter].possibleDirections["South"] = false
            }
            if rooms[checkCounter].coordinate.y == length - 1 {
                rooms[checkCounter].possibleDirections["North"] = false
            }
            checkCounter += 1
        } while checkCounter <= rooms.count - 1
        
// Функци создания двери в комнате. Необходимо, чтобы возвращало строку для генерации лабиринта.
        func createDoor(currentRoom: Int, direction: String)-> String{
            switch direction {
                
            case "North":
                rooms[currentRoom].doors[direction] = true
                rooms[currentRoom + width].doors["South"] = true
                
            case "East":
                rooms[currentRoom].doors[direction] = true
                rooms[currentRoom + 1].doors["West"] = true
                
            case "West":
                rooms[currentRoom].doors[direction] = true
                rooms[currentRoom - 1].doors["East"] = true
                
            case "South":
                rooms[currentRoom].doors[direction] = true
                rooms[currentRoom - width].doors["North"] = true
                
            default:
                print("Неправильно указано направление")
                
            }
            
            return direction
            
        }
        
        // Функция проверки подсоединенности соседних комнат. Нужна для генерации лабиринта.
        
        func isDeadEnd (currentRoom: Int)->Bool {
            
            var result: Bool = true
            for (direction, value) in rooms[currentRoom].possibleDirections{
                
                if value == true {
                    
                    switch direction {
                        
                    case "North":
                        if  rooms[currentRoom + width].isConnected != true{
                            result = false
                        }
                    case "South":
                        if  rooms[currentRoom - width].isConnected != true {
                            result = false
                        }
                    case "East":
                        if rooms[currentRoom + 1].isConnected != true {
                            result = false
                        }
                    case "West":
                        if  result && rooms[currentRoom - 1].isConnected != true {
                            result = false
                        }
                    default:
                        print( "Проблемы в комнате \(currentRoom)")
                    }
                }
            }
            
            return result
            
        }
        
        
// Функция проверки закрытости всех дверей в комнате. нужна для проверки комнаты на тупиковость.
        
        func allDoorsClosed (currentRoom: Int) -> Bool {
            var openedDoors: [String] = []
            for (key, value) in rooms[currentRoom].doors {
                if value == true {
                    openedDoors.append(key)
                }
            }
            return openedDoors.isEmpty
        }
        
// генерация проходов лабиринта. Она очень запутанная. Реально не знаю, как можно сделать её менее запутанной. Комментировал каждое действие, чтобы хоть как-то легче понималось это. Но к такому варианту я пришел после того, как насоздавал все другие более простые варианты. В любом другом случае, получалось, что двери создаются все в каждой комнате. Или вообще не создаются. Я даже где-то сайт нашел описывающий генерацию лабиринтов. Потом понял, что мой способ под один из вариантов подходит. Поэтому, создал правильно.  Но если у вас есть вариант попроще. Даже если не возьмете в команду... Если будет время и это не затруднит - передайте как-нибудь этот способ . Реально интересно, как это можно упростить и разобраться...
        
        var iterationCount = 0
        var roomsPassed:[Int] = []
        var doorsToCreate: [String] = []
        var counter = 0
        
        var connectedRooms: [Room] = []
        repeat {
            connectedRooms = []
// Первым делом, заходя в комнату, проверяем: тупик ли она. Тупик - если вокруг все комнаты присоединены. И в самой комнате нет созданных дверей. Если она тупик - идем обратно и говорим, что комната присоединена. Обратно идти некуда - значит лабиринт сгенерирован. выходим из цикла.
            
            if isDeadEnd(currentRoom: counter), allDoorsClosed(currentRoom: counter) {
                rooms[counter].isConnected = true
                if roomsPassed.isEmpty == false {
                    roomsPassed = roomsPassed.dropLast()
                    counter = roomsPassed.last!
                }
            }
// Заходя в нетупиковую комнату, первым делом нужно понять: есть ли во всех возможных направлениях не присоединенные комнаты
            
            if  isDeadEnd(currentRoom: counter) == false {
                
// Если это так - Проверяем на наличие открытых дверей. Если закрытые есть -
//                    проверям - комната за закрытой дверью присоединена или нет? Если нет - добавляем  в массив doorsToCreate - массив дверей, в которых можно создать дверь.
                
                for (door,value) in rooms[counter].possibleDirections {
                    if value == true && rooms[counter].doors[door] == false {
                        switch door {
                        case "North":
                            if rooms[counter + width].isConnected == false {
                                
                                doorsToCreate.append(door)
                                
                            }
                        case "South":
                            if rooms[counter - width].isConnected == false {
                                doorsToCreate.append(door)
                            }
                        case "West":
                            if rooms[counter - 1].isConnected == false {
                                doorsToCreate.append(door)
                            }
                        case "East":
                            if rooms[counter + 1].isConnected == false {
                                doorsToCreate.append(door)
                            }
                        default:
                            print("Проблемы в комнате \(counter)")
                        }
                    }
                }
// Если массив не пустой: комнату добавляем в массив пройденных комнат, создаем дверь в случайном направлении из возможных и переходим в неё. Так, как её мы присоединим к предыдущей, она сразу становится подсоединенной к остальным дверям лабиринта.
                
                if doorsToCreate.isEmpty != true {
                    
                    roomsPassed.append(counter)
                    
                    let randomizer = Int.random(in: 0...doorsToCreate.count - 1)
                    
                    let createdDirection = createDoor(currentRoom: counter, direction: doorsToCreate[randomizer])
                    
                    rooms[counter].isConnected = true
                    
                    iterationCount += 1
                    
                    switch createdDirection {
                    case "North":
                        
                        counter += width
                        rooms[counter].isConnected = true
                        
                    case "South":
                        
                        counter -= width
                        rooms[counter].isConnected = true
                    case "West":
                        
                        counter -= 1
                        rooms[counter].isConnected = true
                    case "East":
                        
                        counter += 1
                        rooms[counter].isConnected = true
                    default:
                        print("Проблемы с созданием двери в комнате \(counter)")
                    }
                    
                    doorsToCreate = []
                    iterationCount += 1
                    
                }else {
                    
                    // Если в данной комнате двери во всех направлениях созданы - идем в предыдущую комнату
                    if roomsPassed.count > 1 && iterationCount > 0 {
                        roomsPassed = roomsPassed.dropLast()
                        counter = roomsPassed.last!
                    }
                }
            }  else {
                
                // Если все комнаты вокруг присоединены и лабиринт не сгенерирован полностью - идем обратно.
                
                if roomsPassed.count > 1 && iterationCount > 0 {
                    roomsPassed = roomsPassed.dropLast()
                    counter = roomsPassed.last!
                    
                }
            }
            
            for room in rooms{
                if room.isConnected {
                    connectedRooms.append(room)
                    
                }
            }
            
        } while connectedRooms.count < rooms.count
        
        // Функция Генерации вещей в комнатах и темных комнат
        
        counter = 0
        
        repeat {
            
            let darkRandomizer = Int.random(in: 0...99)
            
            if darkRandomizer % 10 == 0 {
                
                rooms[counter].isDark = true
                
            }
            
            rooms[counter].generateObjects()
            
            counter += 1
            
        } while counter <= rooms.count - 1
}
}


