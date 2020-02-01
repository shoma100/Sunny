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
            
            DB.getUserInfo_o(userId: user.uid, comp: {
                value in
                
                if let name = value["name"] {
                    self.unm.text = name
                    self.uid.text = value["id"]
                } else {
                    DB.getUserInfo(userId: user.uid, comp: {
                        item in
                        
                        self.unm.text = item!.getDisplayName()
                        self.uid.text = item!.getSearchId()
                    })
                    
                }
            })
        }
        
        
    }
    
    
    @IBAction func tappedAccountSetting(_ sender: Any) {
        self.performSegue(withIdentifier: "showAccountSegue", sender: nil)
    }
    
}
