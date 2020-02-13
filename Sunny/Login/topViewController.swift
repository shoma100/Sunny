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
                DB.getUserInfo_o(userId: user.uid, comp: {
                    oldUserInfo in
                    
                    if let wn = oldUserInfo["name"]{
                        let name = wn
                        let searchId = oldUserInfo["id"]!
                        let mail = user.email
                        let expain = ""
                        let iconURL = ""
                        let uid = user.uid
                        let account = Account(name: name as! String,
                                              mail: mail!,
                                              explain: expain,
                                              iconURL: iconURL,
                                              userId: uid,
                                              searchId: searchId as! String)
                        DB.addUserDB(user: account)
                    } else {
                        DB.getUserInfo(userId: user.uid, comp: {newUserInfo in
                            let name = newUserInfo!.getDisplayName()
                            let searchId = newUserInfo!.getSearchId()
                            let mail = user.email
                            let expain = ""
                            let iconURL = ""
                            let uid = user.uid
                            let account = Account(name: name,
                                                  mail: mail!,
                                                  explain: expain,
                                                  iconURL: iconURL,
                                                  userId: uid,
                                                  searchId: searchId)
                            DB.addUserDB(user: account)
                        })
                    }
                    self.transitionToView()
                })
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
