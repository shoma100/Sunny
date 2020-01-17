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
    var id:String?
    @IBOutlet weak var name: UILabel!
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    
    override func viewDidLoad() {
  
        print(id)
        
        //        uid.text = user?.uid
                
                ref.child("user").child(id!).observe(.value) { (snapshot) in
                    let data = snapshot.value as? [String : AnyObject] ?? [:]
                    let name = data["name"] as? String
//                    let id = data["id"] as? String
                    self.name.text = name!
                   // self.uid.text = "id：" + id!
                 }
    
    }
    
    @IBAction func add() {
        let data = [id! : true]
        ref.child("friend").child(user!.uid).childByAutoId().setValue(data)
        self.performSegue(withIdentifier: "add", sender: self)
    }
}
