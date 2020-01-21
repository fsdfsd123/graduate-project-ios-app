//
//  video.swift
//  AlamoFireDemo
//
//  Created by csie on 2019/7/3.
//  Copyright © 2019 Frank.Chen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct FsdVideo:Codable{
    var id:String = ""
    var index:String = ""
    var score:Double = 0
    var type:String = ""
    var category:Int = 0
    var chatroomembedded:String = ""
    var language:String = ""
    var status:String = ""
    var title:String = ""
    var host:String = ""
    var tags:String = ""
    var videoid:String = ""
    var videourl:String = ""
    var popular_rate:Double = 0
    var channel:String = ""
    var generaltag:String = ""
    var viewers:Int = 0
    var click_through:Int = 0
    var platform:String = ""
    var videoembedded:String = ""
    var viewcount:Int = 0
    var published:String = ""
    var thumbnails:String = ""
    var description:String = ""
    
}
struct testvideo{
    var channel:String?
    init(channel:String? = nil) {
        self.channel = channel
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}



//func ApifetchData(Api:String) ->[FsdVideo]{
//    var SearchVideo = [FsdVideo()]
//    Alamofire.request("http://120.126.16.88:17777/\(Api)").responseJSON(completionHandler: { response in
//        if response.result.isSuccess {
//
//
//            //let json: JSON = JSON(data: response.data!)
//            do {
//
//                json = try JSON(data: response.data!)
//
//
//
//            } catch {
//
//
//
//            }
//            if let result = json["hits"]["hits"].array{
////                print("\n")
////                print(Api)
////                print(result.count)
//                var channel_list : [String] = []
//                var video = [testvideo()]
//
//                //print(result)
//                for i in 1...result.count-1{
//
//                    let channel = json["hits"]["hits"][i]["_source"]["channel"].string
//                    let id = json["hits"]["hits"][i]["_id"].string
//                    let index = json["hits"]["hits"][i]["_index"].string
//                    let score = json["hits"]["hits"][i]["_score"].double
//                    let type = json["hits"]["hits"][i]["_type"].string
//                    let chatroomembedded = json["hits"]["hits"][i]["_source"]["chatroomembedded"].string
//                    let language = json["hits"]["hits"][i]["_source"]["channel"].string
//                    let status = json["hits"]["hits"][i]["_source"]["status"].string
//                    let title = json["hits"]["hits"][i]["_source"]["title"].string
//                    let host = json["hits"]["hits"][i]["_source"]["host"].string
//                    let tags = json["hits"]["hits"][i]["_source"]["tags"].string
//                    let videoid = json["hits"]["hits"][i]["_source"]["videoid"].string
//                    let videourl = json["hits"]["hits"][i]["_source"]["videourl"].string
//                    let popular_rate = json["hits"]["hits"][i]["_source"]["popular_rate"].double
//                    let generaltag = json["hits"]["hits"][i]["_source"]["generaltag"].string
//                    let viewers = json["hits"]["hits"][i]["_source"]["viewers"].int
//                    let click_through = json["hits"]["hits"][i]["_source"]["click_through"].int
//                    let platform = json["hits"]["hits"][i]["_source"]["platform"].string
//                    let videoembedded = json["hits"]["hits"][i]["_source"]["videoembedded"].string
//                    let viewcount = json["hits"]["hits"][i]["_source"]["viewcount"].int
//                    let published = json["hits"]["hits"][i]["_source"]["published"].string
//                    let thumbnails = json["hits"]["hits"][i]["_source"]["thumbnails"].string
//                    let description = json["hits"]["hits"][i]["_source"]["description"].string
//                    SearchVideo.append(FsdVideo(id: id ?? "", index: index ?? "", score: score ??  0, type: type ?? "", chatroomembedded: chatroomembedded ?? "", language: language ?? "", status: status ?? "", title: title ?? "", host: host ?? "", tags: tags ?? "", videoid: videoid ?? "", videourl: videourl ?? "", popular_rate: popular_rate ?? 0, channel: channel ?? "", generaltag: generaltag ?? "", viewers: viewers ?? 0, click_through: click_through ?? 0, platform: platform ?? "", videoembedded: videoembedded ?? "", viewcount: viewcount ?? 0, published: published ?? "", thumbnails: thumbnails ?? "", description: description ?? ""))
//
//                }
//
//                //                    for i in 0...self.videos.count-1{
//                //                        print(self.videos[i].channel)
//                //                    }
//                for i in 1...SearchVideo.count-1{
//                    SearchVideo[i-1] = SearchVideo[i]
//                }
//                for i in 0...SearchVideo.count-1{
//                    //print(SearchVideo[i].channel)
//                }
//                //return SearchVideo
//                //print(SearchVideo)
//                //self.videos = SearchVideo
//                //homepagevideos = SearchVideo
//                //self.tableView.reloadData()
//                //print(self.videos)
//
//                //self.tableView.reloadData()
//                //super.viewDidLoad()
//
//                //return SearchVideo
//                //print("copydata")
//
//                //                self.searchvideos = SearchVideo
//                //                print(self.searchvideos)
//                //                self.tableView.reloadData()
//                //print(trueVideo)
//                //                self.videos = SearchVideo
//                //                self.VideoCount = self.videos.count
//                //                self.tableView.reloadData()
//                //                super.viewDidLoad()
//            }
//        }
//        else {
//            print("error: \(response.error)")
//        }
//    })
//    //print(SearchVideo)
//    return SearchVideo
//}
//
//func fsd() ->Int{
//    return 1
//}
//func RequestData(Video truevideo:[FsdVideo],Search search :String){
//    Alamofire.request("http://120.126.16.96:17777/?q=\(search)").responseJSON(completionHandler: { response in
//        if response.result.isSuccess {
//            let json: JSON = JSON(data: response.data!)
//            if let result = json["hits"]["hits"].array{
//                print("fsd")
//                print(result.count)
//                var channel_list : [String] = []
//                var video = [testvideo()]
//               
//                //print(result)
//                for i in 1...result.count-1{
//                    
//                    let channel = json["hits"]["hits"][i]["_source"]["channel"].string
//                    let id = json["hits"]["hits"][i]["_id"].string
//                    let index = json["hits"]["hits"][i]["_index"].string
//                    let score = json["hits"]["hits"][i]["_score"].double
//                    let type = json["hits"]["hits"][i]["_type"].string
//                    let chatroomembedded = json["hits"]["hits"][i]["_source"]["chatroomembedded"].string
//                    let language = json["hits"]["hits"][i]["_source"]["channel"].string
//                    let status = json["hits"]["hits"][i]["_source"]["status"].string
//                    let title = json["hits"]["hits"][i]["_source"]["title"].string
//                    let host = json["hits"]["hits"][i]["_source"]["host"].string
//                    let tags = json["hits"]["hits"][i]["_source"]["tags"].string
//                    let videoid = json["hits"]["hits"][i]["_source"]["videoid"].string
//                    let videourl = json["hits"]["hits"][i]["_source"]["videourl"].string
//                    let popular_rate = json["hits"]["hits"][i]["_source"]["popular_rate"].double
//                    let generaltag = json["hits"]["hits"][i]["_source"]["generaltag"].string
//                    let viewers = json["hits"]["hits"][i]["_source"]["viewers"].int
//                    let click_through = json["hits"]["hits"][i]["_source"]["click_through"].int
//                    let platform = json["hits"]["hits"][i]["_source"]["platform"].string
//                    let videoembedded = json["hits"]["hits"][i]["_source"]["videoembedded"].string
//                    let viewcount = json["hits"]["hits"][i]["_source"]["viewcount"].int
//                    let published = json["hits"]["hits"][i]["_source"]["published"].string
//                    let thumbnails = json["hits"]["hits"][i]["_source"]["thumbnails"].string
//                    let description = json["hits"]["hits"][i]["_source"]["description"].string
//                    truevideo.append(FsdVideo(id: id ?? "", index: index ?? "", score: score ??  0, type: type ?? "", chatroomembedded: chatroomembedded ?? "", language: language ?? "", status: status ?? "", title: title ?? "", host: host ?? "", tags: tags ?? "", videoid: videoid ?? "", videourl: videourl ?? "", popular_rate: popular_rate ?? 0, channel: channel ?? "", generaltag: generaltag ?? "", viewers: viewers ?? 0, click_through: click_through ?? 0, platform: platform ?? "", videoembedded: videoembedded ?? "", viewcount: viewcount ?? 0, published: published ?? "", thumbnails: thumbnails ?? "", description: description ?? ""))
//                    //truevideo.append(FsdVideo.init(channel:channel))
//                    print(truevideo[i])
//                }
//            }
//            // 修改後，取得第0筆陣列裡的所在縣市名稱(使用SwiftyJSON)
//            
//        }
//        else {
//            print("error: \(response.error)")
//        }
//    })
//}
