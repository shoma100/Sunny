//
//  AddFriendViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2019/12/19.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var friendId: UITextField!
    let ref = Database.database().reference()
    var uid = ""
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //検索ボタン押下時
    @IBAction func search(_ sender: Any) {
        idSearch(id: friendId.text!, complete: {
            result in
            //nilチェック
            if let id = result {
                self.uid = id
                self.performSegue(withIdentifier: "toAddFriendCheck", sender: nil)
            }
        })
    }
    
    func idSearch(id: String, complete: @escaping (String?) -> Void) {
        ref.child("user").observe(.value) { (snapshot) in
            var resultId:String? = nil
            //FIXME　同じidを持つユーザがいた場合を想定していない,自分を追加できてしまう
            for data in snapshot.children {
                let snapData = data as! DataSnapshot
                // Dictionary型にキャスト
                let user = snapData.value as! [String: Any]
                if id == user["id"] as! String {
                    resultId = snapData.key
                }
            }
            complete(resultId)
        }
    }
    /// セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            // identifierが取れなかったら処理やめる
            return
        }
        if(identifier == "toAddFriendCheck") {
            // segueから遷移先のNavigationControllerを取得
            let vc = segue.destination as! AddFriendAuthViewController
            // 次画面のテキスト表示用のStringに、本画面のテキストフィールドのテキストを入れる
            vc.id = uid
        }
    }
    
    @IBAction func backTo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
