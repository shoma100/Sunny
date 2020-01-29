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
    @IBOutlet weak var accountImg: UIImageView!
    
    override func viewDidLoad() {
        
        // 角を丸くする
        accountImg.contentMode = .scaleAspectFill
        accountImg.layer.cornerRadius = accountImg.frame.width/2
        accountImg.clipsToBounds = true
        
        if let user = Auth.auth().currentUser {
            if let accountImgURL = user.photoURL {
                do {
                    let url = URL(string: accountImgURL.absoluteString)
                    let data = try Data(contentsOf: url!)
                    self.accountImg.image = UIImage(data: data)
                } catch {
                    print(error)
                }
            } else {
                self.accountImg.image = UIImage(named: "AppIcon")
            }
            
            ref.child("user").child(user.uid).observe(.value) { (snapshot) in
                let data = snapshot.value as? [String : AnyObject] ?? [:]
                var name = data["name"] as? String
                var id = data["id"] as? String
                self.unm.text = "ユーザ名：" + name!
                self.uid.text = "id：" + id!
            }
        }
        
        
    }
    
    @IBAction func myUnwindAction(segue: UIStoryboard) {
        
    }
}
