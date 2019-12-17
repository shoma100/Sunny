//
//  MyAccountViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2019/12/16.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit
import Firebase

class MyAccountViewController: UIViewController {
    let ref = Database.database().reference()
    @IBOutlet weak var uid: UILabel!
    @IBOutlet weak var unm: UILabel!
    
    override func viewDidLoad() {
        
        let user = Auth.auth().currentUser
//        uid.text = user?.uid
        
        ref.child("user").child(user!.uid).observe(.value) { (snapshot) in
            let data = snapshot.value as? [String : AnyObject] ?? [:]
            var name = data["name"] as? String
            var id = data["id"] as? String
            self.unm.text = "ユーザ名：" + name!
            self.uid.text = "id：" + id!
         }
    }
}
