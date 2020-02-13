//
//  group.swift
//  Sunny
//
//  Created by しゅん on 2020/01/31.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation

class group {
    
    private var gorupUid:String
    private var groupName:String
    private var groupImagePath:String
    private var memberList:[String:Any]
    private var memberCount:Int
    private var createTimestamp:String
    private var updateTimestamp:String
    
    
    // model生成
    init(groupUid:String,groupName:String,imagePath:URL,memberList:[String:Any],memberCount:Int) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        
        self.gorupUid = groupUid
        self.groupName = groupName
        self.groupImagePath = imagePath.absoluteString
        self.memberCount = memberCount
        self.memberList = memberList
        self.createTimestamp = dateFormatter.string(from: date)
        self.updateTimestamp = dateFormatter.string(from: date)
    }
    
    // DB -> model生成
    init(src:[String:Any]){
        self.gorupUid = src["gorupUid"] as! String
        self.groupName = src["groupName"] as! String
        self.groupImagePath = src["groupImagePath"] as! String
        self.memberCount = src["memberCount"] as! Int
        self.createTimestamp = src["createTimestamp"] as! String
        self.updateTimestamp = src["updateTimestamp"] as! String
        self.memberList = src["memberList"] as! [String : Any]
//        let users = src["memberList"] as! [[String:String]]
//        var t:[Account] = []
//        for i in users {
//            let user = Account(src: i)
//            t.append(user)
//        }
//        self.memberList = t
        
    }
    
    //model -> DB格納
    public func toDictionary() -> [String:Any] {
        return [
            "gorupUid" : gorupUid,
            "groupName" : groupName,
            "groupImagePath" : groupImagePath,
            "memberCount" : memberCount,
            "memberList" : memberList,
            "createTimestamp" : createTimestamp,
            "updateTimestamp": updateTimestamp
        ]
    }
    
    public func getGorupUid() -> String {
        return self.gorupUid
    }
    public func getGroupName() -> String {
        return self.groupName
    }
    public func getGroupImagePath() -> String {
        return self.groupImagePath
    }
    public func getMemberCount() -> Int {
        return self.memberCount
    }
    public func getCreateTimestamp() -> String {
        return self.createTimestamp
    }
    public func getUpdateTimestamp() -> String {
        return self.updateTimestamp
    }
    public func setGorupUid(gorupUid:String) {
        self.gorupUid = gorupUid
    }
    public func setGroupName(groupName:String) {
        self.groupName = groupName
    }
    public func setGroupImagePath(groupImagePath:String) {
        self.groupImagePath = groupImagePath
    }
    public func setMemberCount(memberCount:Int) {
        self.memberCount = memberCount
    }
    public func setCreateTimestamp(createTimestamp:String) {
        self.createTimestamp = createTimestamp
    }
    public func setUpdateTimestamp(updateTimestamp:String) {
        self.updateTimestamp = updateTimestamp
    }
}
