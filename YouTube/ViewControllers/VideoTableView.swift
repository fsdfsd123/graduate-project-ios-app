//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire
import PageMenu
//every kind of videos
class TotalVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    
    //NotificationCenter.default.post(name: .reload, object: nil)
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var lastContentOffset: CGFloat = 0.0
    var change:Bool = false
    var Api :String = ""
    var videos = [FsdVideo]()
    //MARK: Methods
    func customization() {
        self.tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 30, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 30, right: 0)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
    }
    
    func fsdreload(){
        //self.tableView.reloadData()
       
       
        //self.tableView.reloadData()
        print("test")
    }
    
//    func fetchData() {
//        Video.fetchVideos { [weak self] response in
//            guard let weakSelf = self else {
//                return
//            }
//            weakSelf.videos = response
//            weakSelf.videos.myShuffle()
//            weakSelf.tableView.reloadData()
//        }
//    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
        //return ApifetchData(Api: "?q=youtube").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
        //cell.set(video: ApifetchData(Api: "?q=youtube")[indexPath.row])
        cell.set(video: videos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected\(indexPath.row)")
        tempvideo = videos[indexPath.row]
        print(tempvideo.channel)
        NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(notificationValue(_:)), name: NSNotification.Name(rawValue: "sendValue"), object: nil)
        //事件,此时secLabel是用来显示通知传递来的值，此不在赘述
        
        
    }
    
//    @objc func notificationValue(_ notification:Notification) {
//        "testsecond" = notification.object as! String?
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lastContentOffset = scrollView.contentOffset.y;
    }
    
    //MARK: -  ViewController Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        //print("testfadsasd\(ApifetchData(Api: "?q=youtube"))")
        //print(ApifetchData(Api: "?q=youtube"))
        ViewfetchData(Api: self.Api)
        self.tableView.reloadData()
        print(videos.count)
        //print(self.videos)
        //NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
      
    }
    
//    @objc func loadList(notification: NSNotification) {
//        self.ViewfetchData(Api: "?q=\(totalsearch)")
//    }
    
    func ViewfetchData(Api:String) {
        var SearchVideo = [FsdVideo()]
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
                if let result = json["hits"]["hits"].array{
                    //                print("\n")
                    //                print(Api)
                    //                print(result.count)
                    var channel_list : [String] = []
                    var video = [testvideo()]
                    
                    //print(result)
                    for i in 1...result.count-1{
                        
                        let channel = json["hits"]["hits"][i]["_source"]["channel"].string
                        let id = json["hits"]["hits"][i]["_id"].string
                        let index = json["hits"]["hits"][i]["_index"].string
                        let score = json["hits"]["hits"][i]["_score"].double
                        let type = json["hits"]["hits"][i]["_type"].string
                        let chatroomembedded = json["hits"]["hits"][i]["_source"]["chatroomembedded"].string
                        let language = json["hits"]["hits"][i]["_source"]["channel"].string
                        let status = json["hits"]["hits"][i]["_source"]["status"].string
                        let title = json["hits"]["hits"][i]["_source"]["title"].string
                        let host = json["hits"]["hits"][i]["_source"]["host"].string
                        let tags = json["hits"]["hits"][i]["_source"]["tags"].string
                        let videoid = json["hits"]["hits"][i]["_source"]["videoid"].string
                        let videourl = json["hits"]["hits"][i]["_source"]["videourl"].string
                        let popular_rate = json["hits"]["hits"][i]["_source"]["popular_rate"].double
                        let generaltag = json["hits"]["hits"][i]["_source"]["generaltag"].string
                        let viewers = json["hits"]["hits"][i]["_source"]["viewers"].int
                        let click_through = json["hits"]["hits"][i]["_source"]["click_through"].int
                        let platform = json["hits"]["hits"][i]["_source"]["platform"].string
                        let videoembedded = json["hits"]["hits"][i]["_source"]["videoembedded"].string
                        let viewcount = json["hits"]["hits"][i]["_source"]["viewcount"].int
                        let published = json["hits"]["hits"][i]["_source"]["published"].string
                        let thumbnails = json["hits"]["hits"][i]["_source"]["thumbnails"].string
                        let description = json["hits"]["hits"][i]["_source"]["description"].string
                        SearchVideo.append(FsdVideo(id: id ?? "", index: index ?? "", score: score ??  0, type: type ?? "", chatroomembedded: chatroomembedded ?? "", language: language ?? "", status: status ?? "", title: title ?? "", host: host ?? "", tags: tags ?? "", videoid: videoid ?? "", videourl: videourl ?? "", popular_rate: popular_rate ?? 0, channel: channel ?? "", generaltag: generaltag ?? "", viewers: viewers ?? 0, click_through: click_through ?? 0, platform: platform ?? "", videoembedded: videoembedded ?? "", viewcount: viewcount ?? 0, published: published ?? "", thumbnails: thumbnails ?? "", description: description ?? ""))
                        
                    }
                    
                    //                    for i in 0...self.videos.count-1{
                    //                        print(self.videos[i].channel)
                    //                    }
                    for i in 1...SearchVideo.count-1{
                        SearchVideo[i-1] = SearchVideo[i]
                    }
                    for i in 0...SearchVideo.count-1{
                        print(SearchVideo[i].channel)
                    }
                    self.videos = SearchVideo
                    //VC.reloadInputViews()
                    self.tableView.reloadData()
                    
                    //return SearchVideo
                    //print(SearchVideo)
                    //self.videos = SearchVideo
                    //homepagevideos = SearchVideo
                    //self.tableView.reloadData()
                    //print(self.videos)
                    
                    //self.tableView.reloadData()
                    //super.viewDidLoad()
                    
                    //return SearchVideo
                    //print("copydata")
                    
                    //                self.searchvideos = SearchVideo
                    //                print(self.searchvideos)
                    //                self.tableView.reloadData()
                    //print(trueVideo)
                    //                self.videos = SearchVideo
                    //                self.VideoCount = self.videos.count
                    //                self.tableView.reloadData()
                    //                super.viewDidLoad()
                }
            }
            else {
                print("error: \(response.error)")
            }
        })
        //print(SearchVideo)
        //return SearchVideo
    }
  
}

//TableView Custom Classes
class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var channelPic: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoDescription: UILabel!
    
    func customization()  {
        self.channelPic.layer.cornerRadius = 24
        self.channelPic.clipsToBounds  = true
        self.durationLabel.layer.borderWidth = 0.5
        self.durationLabel.layer.borderColor = UIColor.white.cgColor
        self.durationLabel.sizeToFit()
    }
    
    func set(video: FsdVideo)  {
//        self.videoThumbnail.image = video.thumbnail
//        self.durationLabel.text = " \(video.duration.secondsToFormattedString()) "
//        self.durationLabel.layer.borderColor = UIColor.lightGray.cgColor
//        self.durationLabel.layer.borderWidth = 1.0
//        self.channelPic.image = video.channel.image
//        self.videoTitle.text = video.title
//        self.videoDescription.text = "\(video.channel.name)  • \(video.views)"
        let url = URL(string:video.thumbnails)
        self.videoThumbnail.kf.setImage(with: url)
        self.videoTitle.text = video.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.videoThumbnail.image = UIImage.init(named: "emptyTumbnail")
        self.durationLabel.text = nil
        self.channelPic.image = nil
        self.videoTitle.text = nil
        self.videoDescription.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
    }
}
