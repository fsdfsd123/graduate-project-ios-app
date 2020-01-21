//
//  ilivenetuser.swift
//  YouTube
//
//  Created by csie on 2019/7/25.
//  Copyright © 2019 Haik Aslanyan. All rights reserved.
//

import Foundation
import Firebase
struct history:Convertable{
    var video:FsdVideo
    var videourl:String
    var starttime:Date
    var endtime:Date
    var duration:Int
    
}
struct userSearch:Codable{
    var keyword:String
    var time:Int
}
struct clickthrough:Codable{
    var videourl:String
    var time:Int
}
struct statistics:Codable{
//    struct platform:Codable{
//        var YouTube:Int = 0
//        var Twitch:Int = 0
//        var liveme:Int = 0
//        var Xigua:Int = 0
//        var Live17:Int = 0
//    }
    var platformcount:[String:Int]=["Twitch":0,"YouTube":0, "liveme":0, "17直播":0,"西瓜直播":0,"kingkong":0]
    var platformtime:[String:Int]=["Twitch":0,"YouTube":0, "liveme":0, "17直播":0,"西瓜直播":0,"kingkong":0]
    //var category:category
    var categorytime:[Int:Int] = [
        0:0,
        100:0,
        101:0,
        102:0,
        103:0,
        105:0,
        106:0,
        108:0,
        109:0,
        117:0,
        119:0,
        120:0,
        125:0,
        126:0,
        127:0,
        137:0,
        138:0,
        300:0,
        400:0,
        590:0,
        700:0,
        900:0,
        1000:0
    ]
    var categorycount:[Int:Int] = [
        0:0,
        100:0,
        101:0,
        102:0,
        103:0,
        105:0,
        106:0,
        108:0,
        109:0,
        117:0,
        119:0,
        120:0,
        125:0,
        126:0,
        127:0,
        137:0,
        138:0,
        300:0,
        400:0,
        590:0,
        700:0,
        900:0,
        1000:0
    ]

    
    
}

struct ilivenetuser:Convertable{
    var uid:String = ""
    var name:String = ""
    var photoURL:String = ""
    var email:String = ""
    
    var history:[history]!
    var Subscriptions:[String]!
    var statistics:statistics!
    var userSearch:[userSearch]!
    var recommendlist:[Int]=[101,102,103,104]
    var follow:[String] = [""]
}
//    init(name: String, photoURL: String, email:String,history: [history], Subscriptions: [String] ){
//        self.name = name
//        self.photoURL = photoURL
//        self.email = email
//        self.history = history
//        self.Subscriptions = Subscriptions
//    }

func writeuserdata(){
    let database: DatabaseReference = Database.database().reference()
    database.child("users").child(ilivenetUser.uid).setValue(ilivenetUser.convertToDict())
    
        
    //database.child("users").child(ilivenetUser.uid).child("history").childByAutoId().setValue(ilivenetUser.history.endIndex)
    //database.child("users").child(ilivenetUser.uid).child("statistics").child("platform").value(forKey: <#T##String#>)
}
