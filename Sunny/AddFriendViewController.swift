//
//  AddFriendViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2019/12/19.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import Foundation
import UIKit

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var friendId: UITextField!
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    func Search() {
//        friendSearch(id: "id", complete: {
//            friend in
//
//        })
//    }
//
//    func friendSearch(id: String, complete: @escaping (Dictionary<String, Any>) -> Void) {
//        ref.child("user").child(id).observe(.value) { (snapshot) in
//            // Dictionary型にキャスト
//            let user = snapshot.value as! [String: Any]
//            let friendString = user["name"] as! String
//            complete(user)
//        }
//    }
    
    /// セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
                // identifierが取れなかったら処理やめる
            return
        }
        if(identifier == "toAddFriend") {
                // NavigationControllerへの遷移の場合

                // segueから遷移先のNavigationControllerを取得
            let vc = segue.destination as! AddFriendAuthViewController
                // 次画面のテキスト表示用のStringに、本画面のテキストフィールドのテキストを入れる
            vc.id = self.friendId.text!
        }
//        let next = segue.destination as? AddFriendAuthViewController
//        let _ = next?.view
//        next?.textField3.text = textField.text
    }
    
    
}
