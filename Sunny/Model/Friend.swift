//
//  Friend.swift
//  Sunny
//
//  Created by しゅん on 2020/01/30.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation

class Friend {
    
    private var userId:String!
    private var flg:Bool!
    
    public func getUserId() -> String {
        return self.userId
    }
    
    public func getFlg() -> Bool {
        return self.flg
    }
    
    public func setUserId(userId:String) {
        self.userId = userId
    }
    
    public func setFlg(flg:Bool) {
        self.flg = flg
    }
}
