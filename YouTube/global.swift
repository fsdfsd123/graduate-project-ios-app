//
//  global.swift
//  YouTube
//
//  Created by csie on 2019/7/15.
//  Copyright © 2019 Haik Aslanyan. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase
import NotificationBannerSwift
import Alamofire
var language:String = ""

var platformpage:Int = 0 // pageview 的 初始的 index

var ilivenetUser = ilivenetuser()

var ipaddress:String = "http://120.126.16.88:17777/"

var tempvideo = FsdVideo() //for videodetail

var totalsearch:String = "hi" //for search

var fsdelastic:elastic = elastic()  

var tempvc:String = "homepage"

//var notificationcount:Int

var signalrecommendlive = FsdVideo()
