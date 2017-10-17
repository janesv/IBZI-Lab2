//
//  ViewController.swift
//  IBZI_Lab2
//
//  Created by Sviridova Evgenia on 11.09.17.
//  Copyright © 2017 Sviridova Evgenia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var encryptedMessageLabel: UILabel!
    @IBOutlet weak var decryptedMessageLabel: UILabel!
    @IBOutlet weak var binaryKey: UILabel!
    @IBOutlet weak var VernamCypher: UILabel!
    
    private var key = [String]()
    private var arrayOfSymbols = [String]()
    private var arrayOfCharacters = [String]()
    
    private func check () -> Bool { // проверка вводимых данных
        if textField.hasText {
            print("\nInput text has been entered succesfully")
            for i in textField.text!.characters {
                if "0"..."9" ~= i {
                    print("Error: NO DIGITS should be in this field!")
                    return false
                } else if i == " " {
                    print("Error: NO SPACES should be in this field!")
                    return false
                }
            }
        } else {
            print("Error: Text field is empty!")
            return false
        }
        return true
    }
    
    private func convertToUInt8(toUInt8 fragment: [String]) -> UInt8 { // конвертирование фрагмента строки (буквы) из двоичного кода в UInt8 кодировку
        var result = ""
        for i in 0...6 {
            result += fragment[i]
        }
        let fragmentToUInt8 =  UInt8(result, radix: 2)!
        return fragmentToUInt8
    }
    
    private func convertToBinary(text: String) -> [String] { // получение двоичного кода введенной строки
        var binaryArray = [String]()
        let encodingString = text.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let binaryString = encodingString!.reduce("") { (acc, byte) -> String in
            acc + String(byte, radix: 2)
        }
        encryptedMessageLabel.text = binaryString // вывод на экран двоичного кода исходного сообщения
        print("Binary code of the Message: ", binaryString) // вывод в консоль
        for character in binaryString.characters {
            binaryArray.append(String(character))
        }
        return binaryArray
    }
    
    private func randomGenerate(length: Int) -> [String] { // генерация ключа из 0 и 1 случайным образом
        var randomArray = [String]()
        var keyStringTodisplay = "" // переменная для вывода ключа на экран
        for _ in 0 ..< length {
            let randomIndex = arc4random_uniform(2)
            randomArray.append(String(randomIndex))
            keyStringTodisplay += String(randomIndex)
        }
        binaryKey.text = keyStringTodisplay
        return randomArray
    }
    
    private func decryptionOfTheMessage(keyToDecrypt key: [String], message: String) -> String { // расшифровка сообщения
        var resultText = [String]() // массив для хранения результата расшифровки
        var arrayForMessage = [String]()
        for character in message.characters {
            arrayForMessage.append(String(character))
        }
        print("Array for Message: ", arrayForMessage)
        
        for i in 0 ..< arrayForMessage.count {
            if key[i] == arrayForMessage[i] { // реализация работы бинарного оператора "исключающее ИЛИ"
                resultText.append("0")
            } else {
                resultText.append("1")
            }
        }
        
        var result = [UInt8]()
        var i = 0
        
        repeat {
            var fragment = [String]()
            for j in 0...6 {
                let index = resultText.index(after: j + i) - 1
                print(index)
                fragment.append(resultText[index])
            }
            i += 7
            print("res:", fragment)
            let externalMessage = convertToUInt8(toUInt8: fragment)
            print("UInt8 code of a letter of the external message: ", externalMessage)
            result.append(externalMessage)
        } while i < resultText.count
        let str = String(bytes: result, encoding: String.Encoding.utf8) // расшифрованное сообщение
        return str!
    }
    
    private func encryptionOfTheMessage() -> (result: String, key: [String]) { // шифровка сообщения
        var resultText = "" // переменная для хранения шифровки
        let binaryText = convertToBinary(text: String(textField.text!))
        let binaryKey = randomGenerate(length: binaryText.count) // генерация ключа
        for i in 0 ..< binaryText.count {
            if binaryText[i] == binaryKey[i] { // реализация работы бинарного оператора "исключающее ИЛИ"
                resultText += "0"
            } else {
                resultText += "1"
            }
        }
        return (resultText, binaryKey)
    }
    
    @IBAction private func encryptionButton(_ sender: UIButton) {
        if check() {
            let resultOfEncryption = encryptionOfTheMessage()
            key = resultOfEncryption.key
            VernamCypher.text = resultOfEncryption.result // вывод на экран шифровки
            
            let result = decryptionOfTheMessage(keyToDecrypt: key, message: resultOfEncryption.result)
            print("Decryption: ", result)
            decryptedMessageLabel.text = result // вывод на экран расшифрованного сообщения
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


