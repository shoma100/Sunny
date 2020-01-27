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
    
    let ref = Database.database().reference()
    @IBOutlet weak var friendId: UITextField!
    var uid = ""
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func search(_ sender: Any) {
        idSearch(id: friendId.text!, complete: {
            uid in
            print(uid)
            self.uid = uid
            self.performSegue(withIdentifier: "toAddFriendCheck", sender: nil)
        })
    }
    
    func idSearch(id: String, complete: @escaping (String) -> Void) {
        ref.child("user").observe(.value) { (snapshot) in
            //            Users直下のデータの数だけ繰り返す。
            for data in snapshot.children {
                let snapData = data as! DataSnapshot
                // Dictionary型にキャスト
                let user = snapData.value as! [String: Any]
                if id == user["id"] as! String {
                    complete(snapData.key)
                }
            }
        }
    }
    /// セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            // identifierが取れなかったら処理やめる
            return
        }
        if(identifier == "toAddFriendCheck") {
            // NavigationControllerへの遷移の場合
            
            // segueから遷移先のNavigationControllerを取得
            let vc = segue.destination as! AddFriendAuthViewController
            // 次画面のテキスト表示用のStringに、本画面のテキストフィールドのテキストを入れる
            vc.id = uid
        }
        //        let next = segue.destination as? AddFriendAuthViewController
        //        let _ = next?.view
        //        next?.textField3.text = textField.text
    }

}
