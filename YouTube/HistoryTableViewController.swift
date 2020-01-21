//
//  HistoryTableViewController.swift
//  YouTube
//
//  Created by csie on 2019/8/13.
//  Copyright © 2019 Haik Aslanyan. All rights reserved.
//

import UIKit
import GTMRefresh
import Alamofire
import SwiftyJSON
class HistoryTableViewController: UITableViewController {

    
    var currentIsInBottom:Bool = false
    var from:Int = 0
    var size:Int = 10
    var vctype:String = "history"
    var truevideo = [FsdVideo()]
    //var total = ilivenetUser.history.count
    //上下滑動刷新的func
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    @objc func endRefresing() {
        self.tableView.reloadData()
        self.tableView.endRefreshing(isSuccess: true)
    }
    func loadMore() {
        perform(#selector(endLoadMore), with: nil, afterDelay: 3)
    }
    
    @objc func endLoadMore() {
        self.tableView.endLoadMore(isNoMoreData: true)
    }
    //上下滑動刷新的func
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadfollow(noti:)), name: NSNotification.Name(rawValue: "reloadfollow"), object: nil)
        self.tableView.backgroundColor = UIColor.rbg(r: 80, g: 80, b: 80)
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = item
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .white
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.gtm_addRefreshHeaderView {
            [weak self] in
            print("excute refreshBlock")
            self?.refresh()
        }
        
        self.tableView.gtm_addLoadMoreFooterView {
            [weak self] in
            print("excute loadMoreBlock")
            self?.loadMore()
        }
        self.tableView.pullDownToRefreshText("refresh")
            .releaseToRefreshText("refresh")
            .refreshSuccessText("refresh")
            .refreshFailureText("refresh")
            .refreshingText("refresh")
        
        // color
        self.tableView.headerTextColor(.red)
        //上下滑動刷新的func
        if(self.vctype == "follow"){
            var api = "http://120.126.16.88:17777/subscription?status=true&subscription="
            for i in ilivenetUser.follow{

                api.append("\(i),")
            }
            api.removeLast()
            fetchdata(Api: api)
            print(self.truevideo)
        }

        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.vctype == "history"){
            if(ilivenetUser.history[0].duration == -1){
                return 0
            }
            return ilivenetUser.history.count
        }
        else if(self.vctype == "follow"){
  
            return self.truevideo.count
            
        }
        else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(vctype == "history"){
            tempvideo = ilivenetUser.history.reversed()[indexPath.row].video
        }
        else{
            tempvideo = self.truevideo[indexPath.row]
        }
    Alamofire.request("\(ipaddress)update_click_through?videourl=\(tempvideo.videourl)")
        
         //向伺服器回傳哪部影片被點擊
        let title = ["Twitch", "YouTube", "liveme", "17直播", "西瓜直播","kingkong"]
        var judge:Bool = false
        for i in title{
            if(tempvideo.platform==i){
                judge = true
            }
        }
        if(judge){
            ilivenetUser.statistics.platformcount[tempvideo.platform]!+=1
        }
      
        var categorytitle:[Int:Int]=[
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
        var judge2:Bool = false
        for i in categorytitle.keys{
            if(tempvideo.category == i){
                judge2 = true
            }
        }
        if(judge2){
            ilivenetUser.statistics.categorycount[tempvideo.category]!+=1
        }
//        switch tempvideo.platform {
//        case "Twitch":
//            ilivenetUser.statistics.platform.Twitch+=1
//        case "Youtube":
//            ilivenetUser.statistics.platform.YouTube+=1
//        case "FaceBook":
//            ilivenetUser.statistics.platform.liveme+=1
//        case "17":
//            ilivenetUser.statistics.platform.Live17+=1
//        case "西瓜":
//            ilivenetUser.statistics.platform.Xigua+=1
//        case "Youtube":
//            ilivenetUser.statistics.platform.YouTube+=1
//        default:
//            print("")
//        }
       //user data
        
        let starttime:Date = Date()//記錄點擊影片的瞬間
        let notificationName = Notification.Name("GetStartTime")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["StartTime":starttime])
        //向playerview或者webview呼叫計時的func,并傳遞starttime
        //print(type(of: starttime.timeIntervalSince1970))
        
        if(tempvideo.platform == "YouTube" || tempvideo.platform == "Twitch"){
            NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil)
            //"youtube" or "twitch" 跳轉到playerview用播放器播放
        }
        else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "VideoWebView") as! VideoWebView
            vc.startTime = starttime
            self.navigationController?.pushViewController(vc, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("HidePlyerView"), object: nil)
            //其他平台未抓到直播源的則直接跳轉到網頁
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier:"HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        var temphistory :[history] = [history(video: FsdVideo(), videourl: "", starttime: Date(), endtime: Date(), duration: 0)]
        //print("total\(total)")
        //var temphistory:[history]!
        cell.backgroundColor = UIColor.rbg(r: 80, g: 80, b: 80)
        cell.StartTimeLabel.textColor = .white
        cell.EndTimeLabel.textColor = .white
        cell.DurationLabel.textColor = .white
        cell.VideoTitile.textColor = .white
        func loadcell(){
            print("vctype\(vctype)")
            if(vctype == "history" ){
                cell.HistoryVideo = temphistory[indexPath.row].video
                
                cell.StartTimeLabel.text = temphistory[indexPath.row].video.title
                cell.EndTimeLabel.text = "time: \(describing: temphistory[indexPath.row].starttime)"
                cell.DurationLabel.text = "\(describing: temphistory[indexPath.row].duration)seconds"
                
                let url = URL(string:temphistory[indexPath.row].video.thumbnails )
                cell.VideoImage.kf.setImage(with: url)
                
                cell.VideoTitile.text = temphistory[indexPath.row].video.host
            }
            else if(vctype == "follow"){
                self.truevideo = self.truevideo.reversed()
                if(self.truevideo[0].videourl != ""){
                    print("follow video indexpath :\(self.truevideo[indexPath.row])")
                    let url = URL(string:self.truevideo[indexPath.row].thumbnails )
                    cell.VideoImage.kf.setImage(with: url)
                    cell.VideoTitile.text = self.truevideo[indexPath.row].host
                    cell.StartTimeLabel.text = self.truevideo[indexPath.row].title
                    cell.EndTimeLabel.text = self.truevideo[indexPath.row].platform
                    cell.DurationLabel.text = "\((self.truevideo[indexPath.row].popular_rate))"
                    cell.HistoryVideo = self.truevideo[indexPath.row]
                }
            }
            else{
                return
            }
            //cell.StartTimeLabel.text = "\(temphistory[indexPath.row].starttime)"
            
            //cell.EndTimeLabel.text = String(describing: temphistory[indexPath.row].endtime) ?? ""
            

        }
        self.showSpinner(onView: self.tableView)
        temphistory = ilivenetUser.history.reversed()
        
        loadcell()
        self.removeSpinner()
        
////        temphistory = ilivenetUser.history
////        loadcell()
//        if(ilivenetUser.history.count<=size){
//            temphistory = ilivenetUser.history
//            //temphistory.remove(at: 0)
//            loadcell()
////            if(indexPath.row < ilivenetUser.history.count){
////               loadcell()
////            }
//        }
//
//
//
//        if(ilivenetUser.history.count>size){
//
//            for i in from...(size-1){
//                temphistory.append(ilivenetUser.history[i])
//
//
//            }
//            loadcell()
//        }
//            //temphistory.remove(at: 0)
          
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        //偵測collectionview滑動的func
        var height = scrollView.frame.size.height
        var contentOffsetY = scrollView.contentOffset.y
        var bottomOffset = scrollView.contentSize.height - contentOffsetY
        if (bottomOffset <= height)
        {
            //在最底部
            self.currentIsInBottom = true
            
            print("you are in the bottom")
            
        }
        else
        {
            self.currentIsInBottom = false
        }

    }
    @objc func reloadfollow(noti:Notification){
            if(self.vctype == "follow"){
            var api = "http://120.126.16.88:17777/subscription?status=true&subscription="
            for i in ilivenetUser.follow{
               
                api.append("\(i),")
            }
                api.removeLast()
            fetchdata(Api: api)
            print(self.truevideo)
        }
    }
    
    
        func fetchdata(Api:String){
            print("fsd follow api\(Api)")
            //let url = "\(ipaddress)\(Api)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            //生成url
            //用alamofire發送request
            Alamofire.request(Api).responseJSON(completionHandler: { response in
                if response.result.isSuccess {
                    var json:JSON = []
                    //let json: JSON = JSON(data: response.data!)
                    do {
                        json = try JSON(data: response.data!)//讀取json檔案
                     
                    } catch {
                        return
                    }
                    if(json.isEmpty){
                        print("error")
                        return
                    }
                    print("follow json\(json)")
                    if let result = json.array{
                     
                        //print(SearchResult)
                        print(result.count)
                        var channel_list : [String] = []
                        var video = [testvideo()]
                        var SearchVideo = [FsdVideo()]

                        if json.isEmpty{
                            
                            print("error")
                            //self.test.isHidden = true
//                            self.Methord = "q"
//                            self.reloadApi()
//                            self.fetchdata(Api: self.Api)
                            return
                            //如果?platform沒有讀取到資料，則改用?q的api
                            
                        }
    //                    for i in 0...result.count-1{
    //                        print("i am in")
    //                        let dic = json["hits"]["hits"][i]["_source"] as? NSDictionary
    //                        let data = try! JSONSerialization.data(withJSONObject: dic, options: [])
    //                        self.truevideo[i] = try! JSONDecoder().decode(FsdVideo.self, from: data)
    //                    }
                        for i in 0...result.count-1{
                            let channel = json[i]["data"][0]["_source"]["channel"].string
                            let id = json[i]["data"][0]["_id"].string
                            let index = json[i]["data"][0]["_index"].string
                            let score = json[i]["data"][0]["_score"].double
                            let type = json[i]["data"][0]["_type"].string
                            let category =  json[i]["data"][0]["_source"]["category"].int
                            let chatroomembedded = json[i]["data"][0]["_source"]["chatroomembedded"].string
                            let language = json[i]["data"][0]["_source"]["channel"].string
                            let status = json[i]["data"][0]["_source"]["status"].string
                            let title = json[i]["data"][0]["_source"]["title"].string
                            let host = json[i]["data"][0]["_source"]["host"].string
                            let tags = json[i]["data"][0]["_source"]["tags"].string
                            let videoid = json[i]["data"][0]["_source"]["videoid"].string
                            let videourl = json[i]["data"][0]["_source"]["videourl"].string
                            let popular_rate = json[i]["data"][0]["_source"]["popular_rate"].double
                            let generaltag = json[i]["data"][0]["_source"]["generaltag"].string
                            let viewers = json[i]["data"][0]["_source"]["viewers"].int
                            let click_through = json[i]["data"][0]["_source"]["click_through"].int
                            let platform = json[i]["data"][0]["_source"]["platform"].string
                            let videoembedded = json[i]["data"][0]["_source"]["videoembedded"].string
                            let viewcount = json[i]["data"][0]["_source"]["viewcount"].int
                            let published = json[i]["data"][0]["_source"]["published"].string
                            let thumbnails = json[i]["data"][0]["_source"]["thumbnails"].string
                            let description = json[i]["data"][0]["_source"]["description"].string
                            self.truevideo.append(FsdVideo(id: id ?? "", index: index ?? "", score: score ??  0, type: type ?? "", category:category ?? 0,chatroomembedded: chatroomembedded ?? "", language: language ?? "", status: status ?? "", title: title ?? "", host: host ?? "", tags: tags ?? "", videoid: videoid ?? "", videourl: videourl ?? "", popular_rate: popular_rate ?? 0, channel: channel ?? "", generaltag: generaltag ?? "", viewers: viewers ?? 0, click_through: click_through ?? 0, platform: platform ?? "", videoembedded: videoembedded ?? "", viewcount: viewcount ?? 0, published: published ?? "", thumbnails: thumbnails ?? "", description: description ?? ""))
                            //講讀取到的json檔的每個值載入到fsdvideo struct 內不同的var 中
                            print("test fsd videourl\(videourl)")
                        }
                        
                        
                        self.truevideo.remove(at: 0)//json第一個為空，所以remove
                        print("follow truevideo\(self.truevideo)")
                        self.showSpinner(onView: self.view)
                        self.tableView.reloadData()//重新刷新collectionview
                        self.removeSpinner()
                    }
                }
                else {
                    print("error: \(response.error)")
                }
            })
           
        }
}

/*
 
 if(indexPath.row <= from+size){
               loadcell()
           }
           
           if(self.currentIsInBottom){
               if((total-size)>=0){
                   self.from = self.from + size
                   
                   for i in from...from+size-1{
                       temphistory.append(ilivenetUser.history[i])
                   }
                   total-=10
               }
               else{
                   self.from = self.from + size
                   for i in from...from+total-size{
                       temphistory.append(ilivenetUser.history[i])
                   }
               }
               self.currentIsInBottom = false
               self.tableView.reloadData()
               //如果已經滑動到底部，則再讀取size筆數據
           }
       }
 */
