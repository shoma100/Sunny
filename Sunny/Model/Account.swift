//
//  User.swift
//  Sunny
//
//  Created by しゅん on 2020/02/01.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation
class Account {
    
    private let displayName:String
    private let explain:String
    private let iconURL:String?
    private let userId:String
    private let searchId:String
    private let mail:String
    private let insertTimestamp:String
    private let updateTimestamp:String
    private let group:[String:Bool]?

    init(name:String,mail:String,explain:String?,iconURL:String?,userId:String,searchId:String,group:[String:Bool]) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        
        self.displayName = name
        self.userId = userId
        self.mail = mail
        self.explain = explain ?? ""
        self.iconURL = iconURL ?? ""
        self.insertTimestamp = dateFormatter.string(from: date)
        self.updateTimestamp = dateFormatter.string(from: date)
        self.searchId = searchId
        self.group = group
    }
    
    init(src:[String:Any]) {
        self.displayName = src["displayName"] as! String
        self.userId = src["userId"] as! String
        self.mail = src["mail"] as! String
        self.explain = src["explain"] as! String
        self.iconURL = src["iconURL"] as! String
        self.insertTimestamp = src["insertTimestamp"] as! String
        self.updateTimestamp = src["updateTimestamp"] as! String
        self.searchId = src["searchId"] as! String
        self.group = src["group"] as? [String:Bool]
    }
    
    init(displayName: String, userId: String,mail: String,searchId: String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        
        self.displayName = displayName
        self.userId = userId
        self.mail = mail
        self.explain = ""
        self.iconURL = nil
        self.insertTimestamp = dateFormatter.string(from: date)
        self.updateTimestamp = dateFormatter.string(from: date)
        self.searchId = searchId
        self.group = [String: Bool]()
    }
    
    public func getUserId() ->  String {
        return self.userId
    }
    public func getDisplayName() ->  String {
        return self.displayName
    }
    public func getMail() ->  String {
        return self.mail
    }
    public func getExplain() ->  String? {
        return self.explain
    }
    public func getInsertTimestamp() ->  String {
        return self.insertTimestamp
    }
    public func getUpdateTimestamp() ->  String {
        return self.updateTimestamp
    }
    public func getSearchId() -> String {
        return self.searchId
    }
    public func getIconURL() -> String? {
        return self.iconURL
    }
    public func getGroup() -> [String:Bool]? {
        return self.group
    }
    
    func toDictionary() -> [String:Any] {
        return [
            "displayName":displayName,
            "userId" : userId,
            "mail" : mail,
            "explain" : explain,
            "iconURL" : iconURL,
            "insertTimestamp" : insertTimestamp,
            "updateTimestamp" : updateTimestamp,
            "searchId" :searchId,
            "group" : group,
        ]
    }
}
