//
//  TableViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2020/01/17.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FriendTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    var friends : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    //最初からあるコード
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let tblBackColor: UIColor = UIColor.clear
        tableView.backgroundColor = tblBackColor
        dbConnect()
    }
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func dbConnect() {
        getFrinedIdList(comp: {
            value in
            for key in value {
                self.getFriendUserInfo(userId: key, comp: {
                    friend in
                    self.friends.append(friend)
                    if self.friends.count == value.count {
                        self.tableView.reloadData()
                    }
                    print("friends = ",self.friends)
                })
            }
        })
    }
    
    func getFrinedIdList(comp:@escaping([String]) -> Void) {
        ref.child("friend").child(user!.uid).observe(.value) { (snapshot) in
            //TODO:友達が１人もいない場合には落ちる...
            let keys = [String]((snapshot.value as! [String: Any]).keys)
            print("keys = ",keys)
            
            comp(keys)
        }
    }
    
    func getFriendUserInfo(userId:String, comp:@escaping(String) -> Void) {
        self.ref.child("user").child(userId).observe(.value) { (snapshot) in
            // Dictionary型にキャスト
            let user = snapshot.value as! [String: Any]
            let friendString = user["name"] as! String
            comp(friendString)
        }
    }
    
    
    //セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    //セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Friendcell", for: indexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = friends[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle != .delete {
            return
        }
        let removedData = friends.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        //        removedData.delete()
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        print("セルをタップしました")
    }
    @IBAction func backTo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

