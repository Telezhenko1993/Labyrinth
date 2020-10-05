//
//  ViewControllerLabyrinth.swift
//  Labyrinth
//
//  Created by Евгений Тележенко on 20.04.2020.
//  Copyright © 2020 Евгений Тележенко. All rights reserved.
//

import UIKit

class ViewControllerLabyrinth: UIViewController {
    
    @IBOutlet weak var fieldTextLabel: UILabel!
    @IBOutlet weak var warningTextLabel: UILabel!
    @IBOutlet weak var torchlightLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var actionReadLine: UITextField!
    @IBOutlet weak var takeButtonLabel: UIButton!
    @IBOutlet weak var actionButtonLabel: UIButton!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var dropButtonLabel: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    // Указал данные, т.к без инициализатора, выдаст ошибку. Программа автоматически заменит их на данные пользователя при переходе с прошлой вью на эту.
    

    var width: Int = 4
    var length: Int = 3
    var field: Field = Field(width: 5, length: 5)
    var timer = Timer()
    var counterTimer = 1
    var commandList = UITextView()
    var backButton = UIButton()
    var currentRoom: Room { field.rooms[currentRoomInt]}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.field = Field(width: width, length: length)
        
        actionReadLine.text = ""
        renewDate()
        
    }
    
    
//    func currentRoom() -> Room {
//        for room in field.rooms {
//            if field.player.atRoom!.coordinate == room.coordinate {
//        return room
//        }
//    }
//        print("mistake with room. VCL 53")
//        return Room(coordinate: Point(x: 0, y: 0))
//    }
    
    func walk (direction: WalkDirections) {
        
        switch direction {
            
        case .up:
            guard field.rooms[currentRoomInt].coordinate.y != length - 1 else {break}
            field.player.atRoom?.coordinate.y += 1
            field.player.steps! -= 1
        case .down:
            guard field.rooms[currentRoomInt].coordinate.y != 0 else {break}
            field.player.atRoom?.coordinate.y -= 1
            field.player.steps! -= 1
        case .left:
            guard field.rooms[currentRoomInt].coordinate.x != 0 else {break}
            field.player.atRoom?.coordinate.x -= 1
            field.player.steps! -= 1
        case .right:
            guard field.rooms[currentRoomInt].coordinate.x != width - 1 else {break}
            field.player.atRoom?.coordinate.x += 1
            field.player.steps! -= 1
        }
    }
    // Здесь привязал все 4 кнопки. И в зависимости от кнопки, будет выполнен переход между комнатами.
    @IBAction func moveButtonTapped(_ sender: UIButton) {
        switch sender.titleLabel?.text {
            
        case "North":
            
            if field.rooms[currentRoomInt].possibleDirectionsInString.contains("North"){
                walk(direction: .up)
                renewDate()
            } else {
                warningTextLabel.text = "You can't move in this direction"
            }
        case "South":
            if field.rooms[currentRoomInt].possibleDirectionsInString.contains("South"){
                walk(direction: .down)
                renewDate()
            } else {
                warningTextLabel.text = "You can't move in this direction"
            }
        case "East":
           if field.rooms[currentRoomInt].possibleDirectionsInString.contains("East"){
                walk(direction: .right)
                renewDate()
            } else {
                warningTextLabel.text = "You can't move in this direction"
            }
        case "West":
          if field.rooms[currentRoomInt].possibleDirectionsInString.contains("West"){
                walk(direction: .left)
                renewDate()
            } else {
                warningTextLabel.text = "You can't move in this direction"
            }
        case .none:
            warningTextLabel.text = "Wrong!!!"

        case .some(_):
            warningTextLabel.text = "sender text is \(String(describing: sender.titleLabel?.text))"
        }
        renewDate()
        
    }
    
    @IBAction func commandButtonTapped(_ sender: UIButton) {
        commandList = UITextView(frame: self.view.frame)
        commandList.text = """
        Command List
        
        Take: Anything that room contains
        All - pick up everything from room
        Action:  Food - add 5 steps to your steps counter
        Key - if you are in room with chest, opens chest
        Drop: Drops specified item in current room  
        """
        commandList.textAlignment = .center
        commandList.font = .systemFont(ofSize: 19.0)
        backButton = UIButton(type: .roundedRect)
        backButton.frame = .init(x: commandList.center.x, y: commandList.center.y + 100, width: 50, height: 35)
        backButton.center.x = view.center.x
        backButton.setTitle("back", for: .normal)
        backButton.setTitle("pressed", for: .selected)
        backButton.titleLabel?.font = UIFont(name: "system", size: 19)
        backButton.setTitleColor(.black, for: .normal)
        backButton.setTitleColor(.systemRed, for: .selected)
        backButton.titleLabel?.textAlignment = .center
        
        backButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        self.view.addSubview(commandList)
        self.view.addSubview(backButton)
        
        
        
    }
    
    @objc func tapped () {
        commandList.removeFromSuperview()
        backButton.removeFromSuperview()
    }
    
    // Действия при нажатии кнопки  Take. Описание методов - в Field.
    @IBAction func takeButtonTapped(_ sender: UIButton) {
        
        for content in currentRoom.contents {
            if content.name == actionReadLine.text {
                take(stuff: content)
                renewDate()
                warningTextLabel.text = ""
            } else {
                if actionReadLine.text == "All" {
                    takeAll()
                    renewDate()
                    warningTextLabel.text = ""
                    fieldTextLabel.text = "You are in room (\(currentRoom.coordinate.x)), (\(currentRoom.coordinate.y))"
                } else {
                    renewDate()
                    warningTextLabel.text = "You ordered to take wrong thing"
                }
            }
        }
    }
    
    // Действия при нажатии на кнопку Action.
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        
        renewDate()
        
        switch actionReadLine.text {
            
        case "Open chest","open","open chest", "Open" :
            
            if field.player.backpack[6].count == 1 &&
                
            currentRoom.contents[7].count == 1{
                
                fieldTextLabel.text = "You win! Chest is opened!"
                
                takeButtonLabel.isEnabled = false
                gameOver()
                
                
            } else {
                
                warningTextLabel.text = "No! Find key, go in room with chest and open it!"
            }
        case "Food":
            
            if field.player.backpack[1].count > 0 {
                field.player.backpack[1].count -= 1
                field.player.steps! += 5
                        
                        renewDate()
                        
                        warningTextLabel.text = "Your steps increased by 5"
                    } else {
                    
                    warningTextLabel.text = "You have no food"
            }
            
        case .some:
            
            warningTextLabel.text =  "You ordered to do something wrong"
            
        case .none:
            warningTextLabel.text = "Input something in readline."
        }
        
        
        
    }
    
    // Показывает в строке предупреждений инвентарь
    @IBAction func backpackButtonTapped(_ sender: UIButton) {
       var counter = 0
            warningTextLabel.text = "Your backpack contains "
            field.player.backpack.forEach({if $0.count > 0{
                warningTextLabel.text?.append(contentsOf: $0.name + "- \($0.count) ")
                counter += 1
                } })
        if counter == 0 {
            warningTextLabel.text = "Backpack is empty"
        }
        
    }
    
    // Реализация кнопки Drop
    @IBAction func dropButtonTapped(_ sender: UIButton) {
      
            for content in field.player.backpack {
            if content.name == actionReadLine.text && content.count > 0 {
                content.count -= 1
                currentRoom.contents[content.index].count += 1
            }
            renewDate()
            
    }
    }
    // Обновляет все параметры оформления, в соответствии с текущим состоянием.
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toStartView", sender: self)
    }
    
    
    @objc func timerAction() {
        counterTimer -= 1
        if counterTimer == 0 {
            timer.invalidate()
        }
    }
    
    
}

extension ViewControllerLabyrinth {
    var currentRoomInt: Int { (field.player.atRoom?.coordinate.x)! + field.player.atRoom!.coordinate.y * width}
    func renewDate () {
        
        // Возврат всех параметров к начальным состояниям
        
        takeButtonLabel.isEnabled = true
        actionButtonLabel.isEnabled = true
        torchlightLabel.isHidden = true
        takeButtonLabel.isHidden = false
        actionButtonLabel.isHidden = false
        dropButtonLabel.isEnabled = true
        dropButtonLabel.isHidden = false
     
        
        // Условие конца шагов.
        
        if field.player.steps == 0 {
            
            fieldTextLabel.text = "You loose. Take my apologize."
            gameOver()
        }
        
        // Если комната пустая.
        fieldTextLabel.text = "You are in room(\(currentRoom.coordinate.x)), (\(currentRoom.coordinate.y))."
        if currentRoom.contents.isEmpty  == false {
            fieldTextLabel.text?.append(contentsOf: " There is : ")
            for content in currentRoom.contents {
                if content.count > 0 {
                    fieldTextLabel.text?.append(contentsOf: content.name + " - \(content.count) ")
                }
            }
           
        }
        
      field.rooms[currentRoomInt].possibleDirectionsInString = []
        // Табло шагов
        for (key, value) in field.rooms[currentRoomInt].doors {
            if value == true {
                field.rooms[currentRoomInt].possibleDirectionsInString.append(key)
            }
        }
        directionsLabel.text = "You can move to the  \(field.rooms[(field.player.atRoom?.coordinate.x)! + field.player.atRoom!.coordinate.y * width].possibleDirectionsInString)"
        stepsLabel.text = "Steps: \(field.player.steps!)"
        
      
            
        if field.player.backpack[Torchlight().index].count > 0 {
                torchlightLabel.isHidden = false
                
            } else {
                
                torchlightLabel.isHidden = true
                
            }
        
        
        // Условие темной комнаты.
        
        if field.rooms[currentRoomInt].isDark == true {
            warningTextLabel.text = "You are in the dark room"
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            
            warningTextLabel.text = ""
        }
        
        if field.rooms[currentRoomInt].isDark == true,
            (field.player.backpack[Torchlight().index].count == 0),
            
            (field.rooms[currentRoomInt].contents[Torchlight().index].count == 0 ) {
            
            fieldTextLabel.text = "This room is dark. There is no torchlight. You see only doors."
            
            takeButtonLabel.isEnabled = false
            
            actionButtonLabel.isEnabled = false
            
            torchlightLabel.isHidden = true
            
            takeButtonLabel.isHidden = true
            
            actionButtonLabel.isHidden = true
            
            dropButtonLabel.isHidden = true
            
            dropButtonLabel.isEnabled = false
        }
        
        
        if field.player.backpack[Key().index].count != 1 {
            keyLabel.isHidden = true
        } else {
            keyLabel.isHidden = false
        }
        let possibleDirections = field.rooms[currentRoomInt].possibleDirections
        var counter = 0
        possibleDirections.values.forEach({if $0 == false{
            counter += 1
            }})
        switch counter {
        case 0, 1:
            background.image = UIImage(named: "roomAll")
        case 2: background.image = UIImage(named: "roomLeftRight")
        case 3: background.image = UIImage(named: "roomFront")
        default:
            background.image = UIImage(named: "room")
        }
        let myDirections = field.rooms[currentRoomInt].possibleDirections
        var mycounter = 0
        myDirections.values.forEach({if $0 == false{
            mycounter += 1
            }})
        switch mycounter {
        case 0:
            background.image = UIImage(named: "roomAll.jpg")
        case 1: background.image = UIImage(named: "roomLeftRight.jpg")
        case 2: background.image = UIImage(named: "roomFront.jpg")
        case 3: background.image = UIImage(named: "room.jpg")
        default:
            background.image = UIImage(named: "room.jpg")
        }
        
    }
    
    func gameOver () {
        takeButtonLabel.isEnabled = false
        actionButtonLabel.isEnabled = false
        torchlightLabel.isHidden = false
        takeButtonLabel.isHidden = true
        actionButtonLabel.isHidden = true
        dropButtonLabel.isEnabled = false
        dropButtonLabel.isHidden = true
        warningTextLabel.text = ""
        actionReadLine.isHidden = true
        actionReadLine.isEnabled = false
    }
}

extension ViewControllerLabyrinth {
    
     func take (stuff: RoomContents){

                    if currentRoom.contents[stuff.index].count > 0 {
                        field.player.backpack[stuff.index].count += currentRoom.contents[stuff.index].count
                        currentRoom.contents[stuff.index].count = 0
                    }
        renewDate()
                }
        
        // Тоже будет внутри метода take
        
    func takeAll () {
        
        for anyStuff in currentRoom.contents {
            if anyStuff.count > 0 && anyStuff.name != "Chest"{
                field.player.backpack[anyStuff.index].count += anyStuff.count
                anyStuff.count = 0
            }
        }
        renewDate()
        }
        
        // в последствии - основа для вызова кнопки Drop
        
            func drop (stuff: RoomContents) {
                if field.player.backpack[stuff.index].count > 0 {
                    currentRoom.contents[stuff.index].count += field.player.backpack[stuff.index].count
                    field.player.backpack[stuff.index].count = 0
                }
        }
        
            func eat () {
                if field.player.backpack[1].count > 0 {
                    field.player.backpack[1].count -= 1
                    field.player.steps! += 5
                }
        }
}
