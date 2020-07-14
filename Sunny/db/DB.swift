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
        self.ref.observeSingleEvent(of: DataEventType.value, with: { snapshot in
            // データを取り出し配列に格納しています
            if let values = snapshot.value as? [String:String] {
                let user = Account(src: values)
                comp(user)
            }
        })
    }
    
    /// 指定したsearchIDに該当するユーザ情報を取得
    ///
    /// 該当するsearchIDを取得できない場合にはnilが戻るため
    /// 必ずnilチェックを実施してください
    /// - Parameters:
    ///   - searchId:searchId
    ///   - comp:クロージャー
    public static func searchFriendId(searchId:String,comp:@escaping(Account?) -> Void) {
        self.ref = Database.database().reference().child("search").child(searchId)
        self.ref.observeSingleEvent(of: DataEventType.value, with: { snapshot in
            
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
    public static func getFriendsInfo(userId:String,comp:@escaping([String]) -> Void) {
        //クラス変数の初期化
        var friends:[String] = []
        
        self.ref = Database.database().reference().child("friend").child(userId)
        self.ref.observe(.value, with: { snapshot in
            
            // データを取り出し配列に格納しています
            if let values = snapshot.value as? [String:Any] {
                for value in values.keys {
                    //                    let friend = Friend(dic:val)
                    friends.append(value)
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
    public static func getUserInfo_o(userId:String,comp:@escaping([String:Any]) -> Void) {
        ref = Database.database().reference();
        ref.child("user").child(userId).observe(.value) { (snapshot) in
            let data = snapshot.value as! [String : Any]
            //                var name = data["name"] as? String
            //                var id = data["id"] as? String
            comp(data)
        }
    }
    
    //ユーザの参加しているグループのID取得
    public static func getUserJoinGroup(userId:String,comp:@escaping([[String:Any]]) -> Void) {
        ref = Database.database().reference();
        ref.child("user").child(userId).child("group").observe(.value) { (snapshot) in
            if snapshot.exists() {
                let data = snapshot.value as! [String : Any]
                var info:[[String:Any]] = []
                for groupId in data.keys {
                    getGroupInfo(groupId:groupId, comp: {
                        result in
                        print("result = ",result)
                        info.append(result.toDictionary())
                        if info.count == data.count {
                            print("comp前 = ",info[0])
                            comp(info)
                        }
                    })
                }
            } else {
                comp([])
            }
        }
    }
    //グループのIDをもとにグループの情報取得
    public static func getGroupInfo(groupId:String,comp:@escaping(group) -> Void) {
        ref = Database.database().reference();
        ref.child("group").child(groupId).observe(.value) { (snapshot) in
            let data = snapshot.value as! [String : Any]
            print("data = ",data)
            comp(group.init(src:data))
        }
    }
    
    public static func createRoom(currentId:String,friendId:String){
        ref = Database.database().reference();
        ref.child("room").child(currentId).queryOrdered(byChild: "user").queryEqual(toValue: friendId).observe(.value) {
            (snapshot) in
            if !snapshot.exists() {
                let date = stringFromDate(date:Date(),format: "yyyy-MM-dd HH:mm:ss")
                let myData:[String:Any] = ["updatedAt": date,"user":friendId]
                let friendData:[String:Any] = ["updatedAt": date,"user":currentId]
                let key = ref.child("room").child(currentId).childByAutoId().key
                ref.child("room").child(currentId).child(key!).setValue(myData)
                ref.child("room").child(friendId).child(key!).setValue(friendData)
            }
        }
    }
    
    public static func updateRoom(currentId:String,friendId:String,roomId:String){
        ref = Database.database().reference();
        let date = stringFromDate(date:Date(),format: "yyyy-MM-dd HH:mm:ss")
        let myData:[String:Any] = ["updatedAt": date,"user":friendId]
        let friendData:[String:Any] = ["updatedAt": date,"user":currentId]
        ref.child("room").child(currentId).child(roomId).updateChildValues(myData)
        ref.child("room").child(friendId).child(roomId).updateChildValues(friendData)
    }
    
    //    public static func getChatUserInfo(userId:String,comp:@escaping() -> Void) {
    //        ref = Database.database().reference();
    //        ref.child("user").child(message.sender.senderId).observeSingleEvent(of: DataEventType.value, with: {
    //        (snapshot) in
    //    })
    //
    class func dateFromString(string: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.date(from: string)!
    }
    
    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

