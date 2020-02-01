//
//  database.swift
//  Sunny
//
//  Created by しゅん on 2020/02/01.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation
import Firebase

class DB {
    //データベース
    private static var ref:DatabaseReference!
    private static var changed: AuthStateDidChangeListenerHandle!
    
    /// 指定したユーザIDに該当するユーザ情報を取得
    ///
    /// 該当するユーザIDを取得できない場合にはnilが戻るため
    /// 必ずnilチェックを実施してください
    /// - Parameters:
    ///   - userId:ユーザID
    ///   - comp:クロージャー
    public static func getUserInfo(userId:String,comp:@escaping(Account?) -> Void) {
        self.ref = Database.database().reference().child("user").child(userId)
        self.ref.observe(.value, with: { snapshot in
            
            // データを取り出し配列に格納しています
            if let values = snapshot.value as? [String:String] {
                let user = Account(src: values)
                comp(user)
            }
        })
    }
    
    /// 指定したユーザIDに紐づく友達の配列を取得
    ///
    /// 指定したユーザIDに紐づく友達がいない場合には、空の配列が戻る
    /// - Parameters:
    ///   - userId: ユーザID
    ///   - comp: クロージャー
    public static func getFriendsInfo(userId:String,comp:@escaping([Friend]) -> Void) {
        //クラス変数の初期化
        var friends:[Friend] = []
        
        self.ref = Database.database().reference().child("friend").child(userId)
        self.ref.observe(.value, with: { snapshot in
            
            // データを取り出し配列に格納しています
            if let values = snapshot.value as? [String:[String:Any]] {
                for value in values {
                    let val = value.value
                    let friend = Friend(dic:val)
                    friends.append(friend)
                }
            }
            comp(friends)
        })
    }
    
    
    /// 指定したユーザIDの友達を追加
    /// - Parameter user: ユーザ情報
    public static func addUserDB(user:Account) {
        self.ref = Database.database().reference();
        addSearchUserDB(user: user)
        ref.child("user").child(user.getUserId()).setValue(user.toDictionary())
    }
    
    private static func addSearchUserDB(user:Account) {
        ref.child("search").child(user.getSearchId()).setValue(user.toDictionary())
    }
    
    /// 指定したユーザIDの友達を追加
    /// - Parameters:
    ///   - userId: ユーザID
    ///   - newUser: 追加するユーザ情報
    public static func addFriendDB(userId:String,newUser:Account) {
        ref = Database.database().reference();
        let friend = Friend(user: newUser, blackFlg: false, insertDate: Date())
        let newRF = ref.child("friend").child(userId).childByAutoId()
        newRF.setValue(friend.toDictionary())
    }
    
    //FIXME: データ移行のため暫定実装
    public static func getUserInfo_o(userId:String,comp:@escaping([String:String]) -> Void) {
        ref = Database.database().reference();
        ref.child("user").child(userId).observe(.value) { (snapshot) in
            let data = snapshot.value as! [String : String]
//                var name = data["name"] as? String
//                var id = data["id"] as? String
            comp(data)
        }
    }
    
}
