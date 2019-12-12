//
//  AccountcreateViewController.swift
//  アカウント作成画面
//  Sunny
//
//  Created by 石井翔真 on 2019/12/06.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit
import Firebase

class AccountcreateViewController: UIViewController {

    let ref = Database.database().reference()
    
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var pass_conf: UITextField!
    
    @IBAction func submit() {
        if pass.text! == pass_conf.text! {
            let user = ["name":name.text!, "password":pass.text!]
            
            ref.child("user").child(id.text!).setValue(user)
        }
            
        name.endEditing(true)
        pass.endEditing(true)
        id.endEditing(true)
        pass_conf.endEditing(true)
        
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

