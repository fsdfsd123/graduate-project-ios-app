//
//  TableViewController2.swift
//  UIScrollView With UIPageControl by storyboard
//
//  Created by csie on 2019/7/2.
//  Copyright © 2019 EthanLin. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import Alamofire
import SwiftyJSON
import UserNotifications
import Kingfisher

class TrendingVC: UITableViewController {
    
    
    var hot = [FsdVideo]()
    var mostviewed = [FsdVideo]()
    var recommended = [FsdVideo]()
    var subscriptions = [FsdVideo]()
    var today = [FsdVideo]()
    var upcoming = [FsdVideo]()
    var within72hours = [FsdVideo]()
    var truevideo = [[FsdVideo]()]
    let fullScreenSize = UIScreen.main.bounds.size
    
    var kindname = ["hot","most_viewed","recommended","subscriptions","today","upcoming","within_72_hours"]
    
    lazy var total :[String:[FsdVideo]] = ["hot":hot,"most_viewed":mostviewed,"recommended":recommended,"subscriptions":subscriptions,"today":today,"upcoming":upcoming,"within_72_hours":within72hours]
    
//    var kindname = ["youtube","twitch"]
//
//    var youtube = ["YFJjVLkQKto","BFEakK2FA3s","lWSXOcb4YrM","2GU9kis1hDo","XHbKf8EHSbQ","Ep803Xiso5E"]
//
//    var twitch = ["YFJjVLkQKto","BFEakK2FA3s","lWSXOcb4YrM","2GU9kis1hDo","XHbKf8EHSbQ","Ep803Xiso5E"]
    
//    lazy var kind = [youtube,twitch]
    
    //var truevideo = [FsdVideo()]
    
    var Api:String = "home_page"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchdata(Api: Api)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(kindname.count)
        return kindname.count
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingVCCell", for: indexPath) as! TrendingVCCell
        //cell.headline.text = kindname[indexPath.row]
        cell.headline.text = self.kindname[indexPath.row]
        //cell.myScrollView.contentSize.width = (fullScreenSize.width) * CGFloat(kind[indexPath.row].count)
        cell.myScrollView.contentSize.width = (fullScreenSize.width) * CGFloat(self.kindname[indexPath.row].count)
        cell.myScrollView.contentSize.height = 300
        cell.myScrollView.showsVerticalScrollIndicator = false
        cell.myScrollView.showsHorizontalScrollIndicator = false
        cell.myScrollView.delegate = self
        cell.myScrollView.isPagingEnabled = true

        //cell.myPageControll.numberOfPages = kind[indexPath.row].count
        cell.myPageControll.currentPage = 0
        cell.myPageControll.currentPageIndicatorTintColor = .blue
        cell.myPageControll.pageIndicatorTintColor = .brown
        print("test")
        print(kindname[indexPath.row])
        // Configure the cell...
        //for i in 0...kind[indexPath.row].count-1{
        var end:Int = self.total[kindname[indexPath.row]]?.count ?? 1
        print ("end\(end)")
        if(end != 0){
            for i in 0...end-1{
                cell.myScrollImageview = UIImageView()
//                let gesture = UITapGestureRecognizer(target: cell, action: #selector(TrendingVCCell.singleTap))
//
//                //接著把設定好的偵測事件，指定給ImageView
//                cell.myScrollImageview.addGestureRecognizer(gesture)
                
                cell.myScrollImageview.frame = CGRect(x: fullScreenSize.width * CGFloat(i)+5, y: 25, width: fullScreenSize.width-20, height: 300)
                //cell.myScrollImageview.load(withVideoId: self.total[kindname[indexPath.row]]?[i].channel ?? "")
                
                let url = URL(string:self.total[kindname[indexPath.row]]?[i].thumbnails ?? "")
                print(url)
                cell.myScrollImageview.kf.setImage(with: url)
                cell.myScrollView.addSubview(cell.myScrollImageview)
            }
        }
//        for i  in kindname{
//            cell.myScrollImageview.load(withVideoId: self.total[i].channel ?? "")
//        }
        return cell

    }
    
    func fetchdata(Api:String){
        Alamofire.request("\(ipaddress)\(Api)").responseJSON(completionHandler: { response in
            if response.result.isSuccess {
                var json:JSON = []
                //let json: JSON = JSON(data: response.data!)
                do {
                    json = try JSON(data: response.data!)
                    
                } catch {
                    
                }
                if(json.isEmpty){
                    return
                }
                var kind = self.kindname
                for j in kind{
                    if let result = json[j].array{
                        print("fsd")
                        print(result.count)
                        var channel_list : [String] = []
                        var video = [testvideo()]
                        
                        //print(result)
                        for i in 0...result.count-1{
                            
                            let channel = json[j][i]["_source"]["channel"].string
                            let id = json[j][i]["_id"].string
                            let index = json[j][i]["_index"].string
                            let score = json[j][i]["_score"].double
                            let type = json[j][i]["_type"].string
                            let chatroomembedded = json[j][i]["_source"]["chatroomembedded"].string
                            let language = json[j][i]["_source"]["channel"].string
                            let status = json[j][i]["_source"]["status"].string
                            let title = json[j][i]["_source"]["title"].string
                            let host = json[j][i]["_source"]["host"].string
                            let tags = json[j][i]["_source"]["tags"].string
                            let videoid = json[j][i]["_source"]["videoid"].string
                            let videourl = json[j][i]["_source"]["videourl"].string
                            let popular_rate = json[j][i]["_source"]["popular_rate"].double
                            let generaltag = json[j][i]["_source"]["generaltag"].string
                            let viewers = json[j][i]["_source"]["viewers"].int
                            let click_through = json[j][i]["_source"]["click_through"].int
                            let platform = json[j][i]["_source"]["platform"].string
                            let videoembedded = json[j][i]["_source"]["videoembedded"].string
                            let viewcount = json[j][i]["_source"]["viewcount"].int
                            let published = json[j][i]["_source"]["published"].string
                            let thumbnails = json[j][i]["_source"]["thumbnails"].string
                            let description = json[j][i]["_source"]["description"].string
      
                            self.total[j]?.append(FsdVideo(id: id ?? "", index: index ?? "", score: score ??  0, type: type ?? "", chatroomembedded: chatroomembedded ?? "", language: language ?? "", status: status ?? "", title: title ?? "", host: host ?? "", tags: tags ?? "", videoid: videoid ?? "", videourl: videourl ?? "", popular_rate: popular_rate ?? 0, channel: channel ?? "", generaltag: generaltag ?? "", viewers: viewers ?? 0, click_through: click_through ?? 0, platform: platform ?? "", videoembedded: videoembedded ?? "", viewcount: viewcount ?? 0, published: published ?? "", thumbnails: thumbnails ?? "", description: description ?? ""))
//                            var end = self.total[j]?.count ?? 2
//                            for k in 1...end-2 {
//                                self.total[j]?[k-1] = self.total[j]?[k] ?? FsdVideo()
//                            }
//                            self.total[j]?[end-1] = FsdVideo()
                            
                            //print(channel)
                            print(self.total[j]?[i].platform)
                            print(self.total[j]?[i].channel)
                        }
                        
                    }
                }
                self.reloadInputViews()
            }
            else {
                print("error: \(response.error)")
            }
        })
    }
}

