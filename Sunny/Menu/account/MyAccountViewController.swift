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
    let user = Auth.auth().currentUser
    @IBOutlet weak var uid: UILabel!
    @IBOutlet weak var unm: UILabel!
    @IBOutlet weak var accountImg: UIImageView!
    
    override func viewDidLoad() {
        
        // 角を丸くする
        accountImg.contentMode = .scaleAspectFill
        accountImg.layer.cornerRadius = accountImg.frame.width/2
        accountImg.clipsToBounds = true
        
        ref.child("user").child(user!.uid).observe(DataEventType.value, with: {
            (snapshot) in
            let user = snapshot.value as! [String : Any]
            if let accountImgURL = user["iconURL"] {
                do {
                    let url = URL(string: accountImgURL as! String)
                    let data = try Data(contentsOf: url!)
                    self.accountImg.image = UIImage(data: data)
                } catch {
                    print(error)
                }
            } else {
                self.accountImg.image = UIImage(named: "AppIcon")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        DB.getUserInfo_o(userId: user!.uid, comp: {
            value in
            
            if let name = value["name"] {
                self.unm.text = name
                self.uid.text = value["id"]
            } else {
                DB.getUserInfo(userId: self.user!.uid, comp: {
                    item in
                    
                    self.unm.text = item!.getDisplayName()
                    self.uid.text = item!.getSearchId()
                })
                
            }
        })
    }
    
    
    @IBAction func tappedAccountSetting(_ sender: Any) {
        self.performSegue(withIdentifier: "showAccountSegue", sender: nil)
    }
    
}
