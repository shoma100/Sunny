//
//  AddFriendoAuthViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2019/12/19.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddFriendAuthViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    var id:String!
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        print("追加するid：\(self.id)")
        ref.child("user").child(id).observe(.value) { (snapshot) in
            let data = snapshot.value as? [String : AnyObject] ?? [:]
            let name = data["displayName"] as! String
            self.name.text = name
        }
    }

    @IBAction func backTo(_ sender: Any) {
        backTwo()   
    }
    
    @IBAction func add() {
        ref.child("friend").child(user!.uid).observe(.value) { (snapshot) in
            var data = snapshot.value as? [String : Any] ?? [:]
            data.updateValue(true, forKey: self.id!)
            self.ref.child("friend").child(self.user!.uid).updateChildValues(data)
        }
        //TODO 「追加しました」などの画面表示
        self.backTwo()
    }
    
    func backTwo() {
      // 遷移履歴を二つ戻る
      let count = navigationController!.viewControllers.count - 3
      let target = navigationController!.viewControllers[count]
      navigationController?.popToViewController(target as UIViewController, animated: true)
    }
}
