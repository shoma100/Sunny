//
//  UserDefaultsViewController.swift
//  Sunny
//
//  Created by 黒岡柊人 on 2020/01/29.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation
import UIKit
 
class UserDefaultsViewController: UIViewController, UITextFieldDelegate  {
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard

    // Storyboardと接続↓
    
    
    
    // Storyboardと接続↑
    
    var testText:String = "default"
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // textFiel の情報を受け取るための delegate を設定
        textField.delegate = self
 
        // デフォルト値
        userDefaults.register(defaults: ["DataStore": "default"])
 
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
 
        testText = textField.text!
 
        // キーボードを閉じる
        textField.resignFirstResponder()
 
        saveData(str: testText)
 
        return true
    }
 
    func saveData(str: String){
 
        // Keyを指定して保存
        userDefaults.set(str, forKey: "DataStore")
        userDefaults.synchronize()
        
        // myData という名前で "1" という値を保存する
        userDefaults.set("1", forKey: "myData")
        userDefaults.synchronize()
 
    }
 
    func readData() -> String {

        // myData の値を取り出す
        let lastMyData: String? = userDefaults.object(forKey: "myData") as? String

        // lastMyData を Int 型として扱いたい時は以下のように型変換してみたりする
        if let lastMyDataStr = lastMyData, let lastMyDataInt = Int(lastMyDataStr) {
          // 値があった場合の処理
          // lastMyDataInt を利用してアレコレ…
        }
        else {
          // myData の値がなかった場合の処理
        }
        
        // Keyを指定して読み込み
        let str: String = userDefaults.object(forKey: "DataStore") as! String
 
        return str
    }
}
