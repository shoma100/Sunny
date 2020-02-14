//
//  FriendDetailViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2020/02/13.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation
import UIKit
import Nuke
import Firebase

class FriendDetailViewController: UIViewController {
    
    var id:String = ""
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        DB.getUserInfo(userId: id, comp: {
            userInfo in
            print(userInfo)
            self.name.text = userInfo?.getDisplayName()
            Nuke.loadImage(with: URL(string:(userInfo?.getIconURL())!)!, into: self.image)
        })
    }
    
    //todo:ボタン押下時にroomの作成&互いのuser内のroomにid追加
    @IBAction func startChat(_ sender: Any) {
        if let currentUser = Auth.auth().currentUser {
            DB.createRoom(currentId: currentUser.uid,friendId: id)
            transitionToChatList()
        }
    }
    
    func transitionToChatList() {
        let chatList = self.storyboard?.instantiateViewController(withIdentifier: "chatNavi") as! UINavigationController
        self.present(chatList, animated: true, completion: nil)
    }
}
