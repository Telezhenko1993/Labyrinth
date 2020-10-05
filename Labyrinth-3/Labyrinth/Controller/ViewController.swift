//
//  ViewController.swift
//  Labyrinth
//
//  Created by Евгений Тележенко on 12.04.2020.
//  Copyright © 2020 Евгений Тележенко. All rights reserved.
//

import UIKit

// Основной вью. Здесь будут указываться начальные параметры поля.

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    
// Переменные для передачи их между экранами и задания игрового поля
    var width: Int = 3
    var length: Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        
        // Ограничение на ввод цифр меньше единицы
        if widthTextField.text! != "0" &&
            widthTextField.text! != "1" &&
            lengthTextField.text! != "0" &&
            lengthTextField.text! != "1",
            let width = Int(widthTextField.text!),
            let length = Int(lengthTextField.text!) {
            
//  Передача задынных параметров в текстовое поле.
            self.width = width
            self.length = length

            inputLabel.text = "Field \(width) x \(length) created"
            
// Переход на след. экран
            performSegue(withIdentifier: "toStartTimer", sender: self)
        } else {
            inputLabel.text = "Input labyrinth width and length, the should be more, than 1"
        }
    }
    
// Установил для передачи значения, которые потом отправятся в игровое вью.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ViewControllerTimer
        vc.width = self.width
        vc.length = self.length
    }
}

















