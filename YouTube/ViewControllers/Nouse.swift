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
import Alamofire
import SwiftyJSON
import Kingfisher

class fuck: TotalVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingCell")
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            //cell.set(video: self.videos[indexPath.row - 1])
            return cell
        }
    }
    
    
    /*func homefetchdata(){
    
        var SearchVideo = [FsdVideo()]
        Alamofire.request("http://120.126.16.88:17777/\(Api)").responseJSON(completionHandler: { response in
            if response.result.isSuccess {
                
                
                //let json: JSON = JSON(data: response.data!)
                do {
                    
                    json = try JSON(data: response.data!)
                    
                    
                    
                } catch {
                    
                    
                    
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
                    videos = SearchVideo
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
    }*/
    
}


