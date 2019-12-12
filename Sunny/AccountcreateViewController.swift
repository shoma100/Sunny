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
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var pass_conf: UITextField!
    
    @IBAction func submit() {
            
    //        if pass.text! == pass_conf.text! {
    //            let user = ["name":name.text!, "password":pass.text!, "mail":mail.text!]
    //            ref.child("user").child(id.text!).setValue(user)
    //        }
    //
    //        name.endEditing(true)
    //        pass.endEditing(true)
    //        id.endEditing(true)
    //        pass_conf.endEditing(true)
    //        mail.endEditing(true)
    //        self.performSegue(withIdentifier: "toLogin", sender: nil)
        signUp(email: mail.text!, password: pass.text!, name: name.text!)
        }
         
        private func signUp(email: String, password: String, name: String) {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }
                if let user = result?.user {
                    self.updateDisplayName(name, of: user)
                }
                self.showError(error)
            }
        }
         
        private func updateDisplayName(_ name: String, of user: User) {
            let request = user.createProfileChangeRequest()
            request.displayName = name
            request.commitChanges() { [weak self] error in
                guard let self = self else { return }
                if error != nil {
                    self.performSegue(withIdentifier: "toLogin", sender: nil)
                }
                self.showError(error)
            }
        }
         
        private func sendEmailVerification(to user: User) {
            user.sendEmailVerification() { [weak self] error in
                guard let self = self else { return }
                if error != nil {
                    self.showSignUpCompletion()
                }
                self.showError(error)
            }
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
        
        private func showErrorIfNeeded(_ errorOrNil: Error?) {
            // エラーがなければ何もしません
            guard let error = errorOrNil else { return }
             
            let message = "エラーが起きました" // ここは後述しますが、とりあえず固定文字列
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

}

