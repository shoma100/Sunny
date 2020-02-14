//
//  ChatListViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2020/01/21.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Nuke

class ChatListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var table: UITableView!
    
    //Todo:モデルの配列作ってまとめる
    //画像の配列
    var imgArray: [NSString] = []
    //チャット相手のユーザ名を格納する配列
    var userArray: [NSString] = []
    //
    var keyArray: [NSString] = []
    //
    var userIdArray: [NSString] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userListSet()
    }
    
    //todo:roomのupdatedAt順にソート(queryOrderedByValue使うか配列をソートするか)
    func userListSet() {
        getRoomUsersInfo(comp: {
            snapshots in
            for data in snapshots.children {
                let snapData = data as! DataSnapshot
                let user = snapData.value as! NSDictionary
                self.getUserInfo(uid:user["user"] as! String,comp: {
                    snapshot in
                    let user = snapshot.value as! [String:Any]
                    self.userArray.append(user["displayName"] as! NSString)
                    self.imgArray.append(user["iconURL"] as! NSString)
                    self.userIdArray.append(user["userId"] as! NSString)
                    self.keyArray.append(snapData.key as NSString)
                    print("append後 = ",self.userArray,self.keyArray)
                    if self.userArray.count == snapshots.childrenCount {
                        self.table.reloadData()
                    }
                })
            }
        })
    }
    
    
    
    func getRoomUsersInfo(comp:@escaping(DataSnapshot) -> Void) {
        ref.child("room").child(user!.uid).observe(DataEventType.value, with: { (snapshot) in
            comp(snapshot)
        })
    }
    
    func getUserInfo(uid:String,comp:@escaping(DataSnapshot) -> Void) {
        ref.child("user").child(uid).observe(DataEventType.value, with: { (snapshot) in
            comp(snapshot)
        })
    }
    
    
    //Table Viewのセルの数を指定
    func tableView(_ table: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    
    //各セルの要素を設定する
    func tableView(_ table: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = table.dequeueReusableCell(withIdentifier: "tableCell",
                                             for: indexPath)
    
    // Tag番号 1 で UIImageView インスタンスの生成
            let imageView = cell.viewWithTag(1) as! UIImageView
            //アイコン画像を丸く表示
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = imageView.frame.width/2
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.clipsToBounds = true
            // 画像表示の中心を画面の中心に
            imageView.center = CGPoint(x: 65,y: 54)
    //        imageView.image = img
            Nuke.loadImage(with: URL(string: imgArray[indexPath.row] as String)!, into: imageView)
            
            // Tag番号 ２ で UILabel インスタンスの生成
            let label1 = cell.viewWithTag(2) as! UILabel
            label1.text = userArray[indexPath.row] as String
        
        return cell

    }
    
    // Cell の高さを60にする
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("aaa",keyArray[indexPath.row])
        // 次の画面へ移動
        performSegue(withIdentifier: "ChatDetails", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
                // identifierが取れなかったら処理やめる
            return
        }
             
        if(identifier == "ChatDetails") {
                // NavigationControllerへの遷移の場合

                // segueから遷移先のNavigationControllerを取得
            let vc = segue.destination as! ChatViewController
                // 次画面のテキスト表示用のStringに、本画面のテキストフィールドのテキストを入れる
            print("sender = ",sender)
            vc.roomId = keyArray[sender as! Int] as String
            vc.friendId = userIdArray[sender as! Int] as String
        }
    }
    
    
}
