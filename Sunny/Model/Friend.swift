//
//  Friend.swift
//  Sunny
//
//  Created by しゅん on 2020/01/30.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation

class Friend {
    //フレンドID
    private var friendUid:String
    //ユーザ表示名
    private let displayName:String
    //メールアドレス
    private let mail:String
    //プロフィール
    private let explain:String?
    //ブラックリストフラグ
    private var blackFlg:Bool
    //登録日時
    private let insertTimestamp:String
    //変更日時
    private let updateTimestamp:String
    
    init(user:Account,blackFlg:Bool,insertDate:Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        
        self.friendUid = user.getUserId()
        self.displayName = user.getDisplayName()
        self.mail = user.getMail()
        self.explain = user.getExplain()
        self.blackFlg = blackFlg
        self.insertTimestamp = dateFormatter.string(from: insertDate)
        //生成日時で統一
        self.updateTimestamp = dateFormatter.string(from: insertDate)
    }
    
    init(dic:[String:Any]) {
        self.friendUid = dic["friendUid"] as! String
        self.displayName = dic["displayName"] as! String
        self.mail = dic["mail"] as! String
        self.explain = dic["explain"] as? String
        self.blackFlg = dic["blackFlg"] as! Bool
        self.insertTimestamp = dic["insertTimestamp"] as! String
        self.updateTimestamp = dic["updateTimestamp"] as! String
    }
    
    public func getFriendUid() -> String {
        return self.friendUid
    }
    public func getDisplayName() -> String {
        return self.displayName
    }
    public func getMail() -> String {
        return self.mail
    }
    public func getExplain() -> String? {
        return self.explain
    }
    public func getBlackFlg() -> Bool {
        return self.blackFlg
    }
    public func getInsertTimestamp() -> String {
        return self.insertTimestamp
    }
    public func getUpdateTimestamp() -> String {
        return self.updateTimestamp
    }
    
    func toDictionary() -> [String:Any] {
        return [
            "friendUid" : friendUid,
            "displayName" : displayName,
            "mail" : mail,
            "explain" : explain ?? "",
            "blackFlg" : blackFlg,
            "insertTimestamp" : insertTimestamp,
            "updateTimestamp" : updateTimestamp
        ]
    }
}
