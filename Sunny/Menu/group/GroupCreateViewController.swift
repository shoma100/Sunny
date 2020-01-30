//
//  GroupCreateViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2020/01/27.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class GroupCreateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var friendList: UITableView!
    var friends:[String] = []
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendList.delegate = self
        friendList.dataSource = self
        // 複数選択可にする
        friendList.allowsMultipleSelection = true
        
        if let user = Auth.auth().currentUser {
            dbConnect(uid: user.uid, comp: {
                //くるくる終了
                self.dismissIndicator()
            })
            //くるくる開始
            startIndicator()
            
        }
        
    }
    
    private func dbConnect(uid:String, comp:@escaping() -> Void) {
        getFrinedIdList(uid:uid,comp: {
            value in
            for key in value {
                self.getFriendUserInfo(userId: key, comp: {
                    friend in
                    self.friends.append(friend)
                    if self.friends.count == value.count {
                        self.friendList.reloadData()
                    }
                })
            }
            comp()
        })
    }
    
    func getFriendUserInfo(userId:String, comp:@escaping(String) -> Void) {
        self.ref.child("user").child(userId).observe(.value) { (snapshot) in
            // Dictionary型にキャスト
            let user = snapshot.value as! [String: Any]
            let friendString = user["name"] as! String
            comp(friendString)
        }
    }
    
    func getFrinedIdList(uid:String,comp:@escaping([String]) -> Void) {
        ref.child("friend").child(uid).observe(.value) { (snapshot) in
            var keys:[String] = []
            //TODO:友達が１人もいない場合には落ちる...
            if let friends = snapshot.value {
                keys = [String]((friends as! [String: Any]).keys)
                print("keys = ",keys)
            }
            
            comp(keys)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Groupcell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = friends[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
    }
    
}
