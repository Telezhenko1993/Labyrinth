//
//  ViewControllerTimer.swift
//  Labyrinth
//
//  Created by Евгений Тележенко on 20.04.2020.
//  Copyright © 2020 Евгений Тележенко. All rights reserved.
//

import UIKit

class ViewControllerTimer: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gameStartsLogo: UILabel!
    @IBOutlet weak var okButtonLabel: UIButton!
    
// Здесь решил поставить небольшо йтаймер для красоты. Плюс, Разместил инструкцию.
    var timer = Timer()
    var counterTimer = 3
    var width = 4
    var length = 4
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        gameStartsLogo.isHidden = true
        infoLabel.text = "Правила игры просты. Вы окажетесь в случайной комнате, лабиринта, размеры которого указали. В верхней части экрана будет указана координата комнаты и вещи, которые в ней лежат. Далее - будут указаны возможные направдения для перемещения. Перемещение осуществляется стрелками. Чтобы взять предмет, нужно ввести его название с большой буквы в текстовое поле и нажать кнопку \"Take\". Чтобы взять всё - введите All вместо названия предмета. Кнопка \"Action\" необходима для использования предметов. Таких, как Food или Key. При использовании Food, вам добавляется 5 шагов.  При использовании Key в комнате с сундуком, игра считается выигранной и завершенной. Игра завершится, если количество шагов равно нулю. При попадании в темную комнату, вы не можете ничего брать и видите только двери. Для того, чтобы осветить черную комнату, в вашем инвентаре должен лежать Torchlight.  "
    }
    
    @IBAction func readyButtonTapped(_ sender: UIButton) {
        infoLabel.isHidden = true
        okButtonLabel.isHidden = true
        okButtonLabel.isEnabled = false
        gameStartsLogo.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
// При окончании таймера, будет выполнен переход на другую вью.
    
    @objc func timerAction() {
        counterTimer -= 1
        gameStartsLogo.text = "Game starts in \(counterTimer)"
        
        if counterTimer == 0 {
            timer.invalidate()
            performSegue(withIdentifier: "toTheLabirynth", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ViewControllerLabyrinth
        vc.width = self.width
        vc.length = self.length      
    }
}

