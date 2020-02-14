//
//  LoginViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2019/12/10.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート

class LoginViewController: UIViewController, UITextFieldDelegate {

    var alertController: UIAlertController!
    @IBOutlet var emailTextField: UITextField! // Emailを打つためのTextField

    @IBOutlet var passwordTextField: UITextField! //Passwordを打つためのTextField

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry  = true // 文字を非表示に
        
    }

    @IBAction func swipe(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController() as! CameraViewController
        //右に遷移する
         let transition = CATransition()
         transition.duration = 0.5
        transition.type = CATransitionType.push

        //kCATransitionFromLeftにすれば左に遷移します
        transition.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(nextView, animated: false, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didRegisterUser() {
        //ログインのためのメソッド
        login()
    }
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //ログイン完了後に、ListViewControllerへの遷移のためのメソッド
    func transitionToView()  {
        let storyboard: UIStoryboard = UIStoryboard(name: "Sub", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController() as! UIPageViewController
        self.present(nextView, animated: true, completion: nil)
    }
    
    func login() {
    //EmailとPasswordのTextFieldに文字がなければ、その後の処理をしない
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }

            //signInWithEmailでログイン
            //第一引数にEmail、第二引数にパスワードを取ります
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                //エラーがないことを確認
                if error == nil {
//                    if let loginUser = user {
//                            self.transitionToView()
//                    }
                    if let loginUser = user {
                        // バリデーションが完了しているか確認。完了ならそのままログイン
                        if self.checkUserValidate(user: loginUser.user) {
                            // 完了済みなら、ListViewControllerに遷移
                            self.transitionToView()
                        }else {
                            // 完了していない場合は、アラートを表示
                            self.presentValidateAlert()
                        }
                    }
                }else {
                    self.alert(title: "ログインエラー",message: "ログインに失敗しました")
                    print("error...\(error?.localizedDescription)")
                }
            })
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
    
    func checkUserValidate(user: User)  -> Bool {
        return user.isEmailVerified
    }
    // メールのバリデーションが完了していない場合のアラートを表示
    func presentValidateAlert() {
        let alert = UIAlertController(title: "メール認証", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
