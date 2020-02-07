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
    
    var alertController: UIAlertController!
    var flg = false
    let ref = Database.database().reference()
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var pass_conf: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func submit() {
        //        flg = searchId(id: id.text!)
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
        if pass.text! == pass_conf.text! {
            signUp(email: mail.text!, password: pass.text!, name: name.text!)
        } else{
            self.alert(title: "エラー", message: "パスワードが一致しません")
        }
    }
    
    private func signUp(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let user = result?.user {
                //              self.updateDisplayName(name, of: user)
                self.ref.child("user").child(user.uid).setValue(["id": self.id.text!,"name": self.name.text!])
                self.sendEmailVerification(to: result!.user)
            }
            self.showError(error)
        }
    }
    
    //        private func updateDisplayName(_ name: String, of user: User) {
    //            let request = user.createProfileChangeRequest()
    //            request.displayName = name
    //            request.commitChanges() { [weak self] error in
    //                guard let self = self else { return }
    //                if error != nil {
    //                    self.sendEmailVerification(to: user)
    //                }
    //                self.showError(error)
    //            }
    //        }
    
    private func sendEmailVerification(to user: User) {
        print(user)
        user.sendEmailVerification() { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.transitionToView()
            }
            self.showError(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        mail.layer.cornerRadius = 5.0
//        id.layer.cornerRadius = 5.0
//        name.layer.cornerRadius = 5.0
//        pass.layer.cornerRadius = 5.0
//        pass_conf.layer.cornerRadius = 5.0
//        button.layer.cornerRadius = 5.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func transitionToView()  {
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    private func showError(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard errorOrNil != nil else { return }
        
        let message = "登録できませんでした" // ここは後述しますが、とりあえず固定文字列
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    //    func searchId(id:String) -> (result: Bool) {
    //        ref.child("user").observe(.value) { (snapshot) in
    //            var count = 0
    //            for data in snapshot.children {
    //                let snapData = data as! DataSnapshot
    //                // Dictionary型にキャスト
    //                let user = snapData.value as! [String: Any]
    //
    //                if id == user["id"] as! String {
    //                    count += 1
    //                    var result = true
    //                    return result
    //                }
    //            }
    //        }
    //    }
}

