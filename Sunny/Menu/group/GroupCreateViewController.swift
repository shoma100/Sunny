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
    public var selectedFriends:[Account] = []
    let ref = Database.database().reference()
    var friends:[Account] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendList.delegate = self
        friendList.dataSource = self
        // 複数選択可にする
        friendList.allowsMultipleSelection = true
        
        if let user = Auth.auth().currentUser {
            dataLoad(uid: user.uid, comp: {
                //くるくる終了
                self.dismissIndicator()
            })
            //くるくる開始
            startIndicator()
        }
        
    }
    
    fileprivate func makeNoneView() {
        let groupNoneView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height))
        groupNoneView.backgroundColor = UIColor.white
        let title = UILabel(frame: CGRect(x:self.view.frame.width/2,y: self.view.frame.height/2,width: 250,height:250))
        title.text = "友達がいません"
        title.textAlignment = .center
        title.center = self.view.center
        groupNoneView.addSubview(title)
        self.view.addSubview(groupNoneView)
    }
    
    private func dataLoad(uid:String, comp:@escaping() -> Void) {
        
        DB.getFriendsInfo(userId:uid,comp: {
            value in
            print(value)
            if value.count == 0 {
                self.makeNoneView()
                comp()
            }
            
            for item in value {
                DB.getUserInfo(userId: item, comp: {
                    account in
                    // nilチェック
                    if let _ = account {
                        self.friends.append(account!)
                        self.friendList.reloadData()
                    }
                })
            }
            print("friendlist = ",self.friends)
//            self.friendList.reloadData()
            comp()
        })
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Groupcell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = friends[indexPath.row].getDisplayName()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        selectCheck()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
        selectCheck()
    }
    
    func selectCheck() {
        let nextActionBar = UIBarButtonItem(title: "次へ", style: .plain, target: self, action: #selector(groupSetting))
        if let _ = friendList.indexPathsForSelectedRows {
            self.navigationItem.setRightBarButton(nextActionBar, animated: true)
        } else {
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    @objc func groupSetting(_ selder: UIBarButtonItem) {
        let sortedIndexPaths = friendList.indexPathsForSelectedRows!.sorted { $0.row > $1.row }
        for item in sortedIndexPaths {
            selectedFriends.append(friends[item.row])
        }
        performSegue(withIdentifier: "groupSettingSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupSettingSegue" {
            let nextVC = segue.destination as! GroupSettingViewController
            nextVC.member = self.selectedFriends
        }
    }
    
}
