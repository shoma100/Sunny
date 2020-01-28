//
//  AccountSetViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2019/12/16.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit
import Firebase

class AccountSetViewController: UIViewController {
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    @IBOutlet weak var unm: UILabel!
    
    override func viewDidLoad(){
        
        ref.child("user").child(user!.uid).observe(.value) { (snapshot) in
            let data = snapshot.value as? [String : AnyObject] ?? [:]
            let name = data["name"] as? String
            _ = data["id"] as? String
            self.unm.text = name!
        }
    }
    
    @IBAction func logout() {
        do {
            //do-try-catchの中で、FIRAuth.auth()?.signOut()を呼ぶだけで、ログアウトが完了
            try Auth.auth().signOut()
            
            //先頭のNavigationControllerに遷移
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "top")
            self.present(storyboard, animated: true, completion: nil)
        }catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
    
    @IBAction func backTo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
