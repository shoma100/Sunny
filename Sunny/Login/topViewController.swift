//
//  topViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2019/12/06.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI
import Firebase //Firebaseをインポート

class topViewController: UIViewController,FUIAuthDelegate {
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var google: UIButton!
    @IBOutlet weak var AuthButton: UIButton!
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    
    // 認証に使用するプロバイダの選択
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // authUIのデリゲート
        self.authUI.delegate = self
        self.authUI.providers = providers
        AuthButton.addTarget(self,action: #selector(self.AuthButtonTapped(sender:)),for: .touchUpInside)
        signIn.layer.cornerRadius = 5.0
        signUp.layer.cornerRadius = 5.0
        google.layer.cornerRadius = 5.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //FIXME: データ移行のため暫定対応
        if let user = Auth.auth().currentUser {
            if Auth.auth().currentUser!.isEmailVerified {
                self.transitionToView()
            }
        }
    }
    
    @objc func AuthButtonTapped(sender : AnyObject) {
        // FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        // FirebaseUIのViewの表示
        self.present(authViewController, animated: true, completion: nil)
    }
    
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合
        if error == nil {
            self.performSegue(withIdentifier: "toTopView", sender: self)
        }
        // エラー時の処理をここに書く
    }
    
    //ログイン完了後に、ListViewControllerへの遷移のためのメソッド
    func transitionToView()  {
        let storyboard: UIStoryboard = UIStoryboard(name: "Sub", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController() as! UIPageViewController
        self.present(nextView, animated: true, completion: nil)
    }
}
