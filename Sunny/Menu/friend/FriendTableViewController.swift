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
    var friends : [Account] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    //最初からあるコード
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //        tableView.tableFooterView = UIView()
        //        let tblBackColor: UIColor = UIColor.clear
        //        tableView.backgroundColor = tblBackColor
        dbConnect()
    }
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func dbConnect() {
        getFrinedIdList(comp: {
            value in
            print(value.count)
            if value.count != 0 {
                for key in value {
                    self.getFriendUserInfo(userId: key, comp: {
                        friend in
                        self.friends.append(friend)
                        if self.friends.count == value.count {
                            print("リロードするで！")
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                        print("friends = ",self.friends)
                    })
                }
            } else{
                self.makeNoneView()
            }
        })
    }
    
    func getFrinedIdList(comp:@escaping([String]) -> Void) {
        ref.child("friend").child(user!.uid).observe(.value) { (snapshot) in
            if snapshot.exists() {
                //TODO:友達が１人もいない場合には落ちる...
                let keys = [String]((snapshot.value as! [String: Any]).keys)
                print("keys = ",keys)
                
                comp(keys)
            } else {
                comp([])
            }
        }
    }
    
    func getFriendUserInfo(userId:String, comp:@escaping(Account) -> Void) {
        self.ref.child("user").child(userId).observe(.value) { (snapshot) in
            // Dictionary型にキャスト
            //            let user = snapshot.value as! [String: Any]
            //            let friendString = user["displayName"] as! String
            //            comp(friendString)
            //値が取得できないことは考慮しない
            //             if let value = snapshot.value as? [String:Any] {
            //                 let user = Account(src: value as! [String : String])
            //                 comp(user)
            //             }
            //値が取得できないことは考慮しない
            if let value = snapshot.value as? [String:Any] {
                let user = Account(src: value)
                comp(user)
            }
        }
    }
    
    
    //セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count = ",friends.count)
        return friends.count
    }
    
    //セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Friendcell", for: indexPath)
        
        // セルに表示する値を設定する
        print("セルに入れる値 ＝ ",friends[indexPath.row],indexPath.row)
        cell.textLabel!.text = friends[indexPath.row].getDisplayName()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 別の画面に遷移
        performSegue(withIdentifier: "toFriendData", sender: friends[indexPath.row].getUserId())
    }
    
    fileprivate func makeNoneView() {
        let groupNoneView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height))
        groupNoneView.backgroundColor = UIColor.white
        let title = UILabel(frame: CGRect(x:self.view.frame.width/2,y: self.view.frame.height/2,width: 250,height:250))
        title.text = "友達はいません"
        title.textAlignment = .center
        title.center = self.view.center
        groupNoneView.addSubview(title)
        groupNoneView.backgroundColor = UIColor(red: 255/255, green: 198/255, blue: 122/255, alpha: 1)
        self.view.addSubview(groupNoneView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriendData" {
            let nextVC = segue.destination as! FriendDetailViewController
            nextVC.id = sender as! String
        }
    }
    
}

