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

protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
    func setPreferStatusBarHidden(_ preferHidden: Bool)
}

import UIKit
import AVFoundation
import YoutubePlayer_in_WKWebView
import TwitchPlayer
import AVKit
import ElasticSwift
import ElasticSwiftCodableUtils
import ElasticSwiftCore
import ElasticSwiftQueryDSL
import ElasticSwiftNetworking
import Firebase

class PlayerView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet var VideoPlayer: UIView!
    
    @IBOutlet var TotalVideoPlayer: UIView!
  
    @IBOutlet var TwitchPlayer: TwitchPlayer!

    @IBOutlet var chatroom: WKWebView!

    @IBOutlet weak var minimizeButton: UIButton!

    @IBOutlet var follow: UIButton!
    var issecond = false
    var YouTubePlayer = WKYTPlayerView()

    var video: Video!
    var delegate: PlayerVCDelegate?
    var state = stateOfVC.hidden
    var direction = Direction.none
    var startTime:Date = Date()

    struct NotificationInfo{
        static let message = "message"
    }
    

 
    
    @IBAction func followaction(_ sender: Any) {
        print("fsd test2")
        if(!issecond){
           
            self.follow.setImage(UIImage.init(named: "star3"), for: .normal)
            ilivenetUser.follow.append(tempvideo.videourl)
            if(ilivenetUser.follow[0] == ""){
                           ilivenetUser.follow.remove(at: 0)
            }
            issecond = false
        }
        if(issecond){
            self.follow.setImage(UIImage.init(named: "emptystar"), for: .normal)
            for i in 0...ilivenetUser.follow.count-1{
                print("test follow 5 \(ilivenetUser.follow[i])")
                           if(ilivenetUser.follow[i] == tempvideo.videourl){
                                if(ilivenetUser.follow.count == 1){
                                    ilivenetUser.follow.remove(at: i)
                                    ilivenetUser.follow.append("")
                                    break
                                }
                                else{
                                    ilivenetUser.follow.remove(at: i)
                                    break
                                }
                        }
            }
                      
            issecond = true
        }
        
        let database: DatabaseReference = Database.database().reference()
        database.child("users").child(Auth.auth().currentUser?.uid ?? "hLO3XFmTeOb0jQU3WEhztX3kDHh2").child("follow").setValue(ilivenetUser.follow)
        let notificationName = Notification.Name("reloadfollow")
         NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["reloadhistory":"reload"])
    }
    func customization() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(HidePlyerView(notification:)), name: NSNotification.Name(rawValue: "HidePlyerView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ShowPlayerView(notification:)), name: NSNotification.Name(rawValue: "ShowPlayerView"), object: nil)
        let notificationName = Notification.Name("GetStartTime")
        NotificationCenter.default.addObserver(self, selector: #selector(GetStartTime(noti:)), name: notificationName, object: nil)
        
        //let button = DOFavoriteButton(frame: CGRectMake(0, 0, 44, 44), image: UIImage(named: "star.png"))
        //self.view.addSubview(button)
        self.backgroundColor = UIColor.rbg(r: 109, g: 109, b: 109)
        YouTubePlayer.frame = CGRect(x: 0, y: 0, width:TwitchPlayer.frame.width, height: self.TwitchPlayer.frame.height)
        self.TotalVideoPlayer.addSubview(YouTubePlayer)
        //totalvideoplayer內有兩個播放器，一個twitchvideoplayer(拉ui)，一個youtubeplayer(code)
        
        //Twichvideo set
        if(tempvideo.platform == "Twitch"){
            self.TwitchPlayer.isHidden = false
            self.YouTubePlayer.isHidden = true
        
            TwitchPlayer.setChannel(to: tempvideo.channel)
            print(tempvideo.chatroomembedded)
            
        }
        
        //YoutubeVideo
        if(tempvideo.platform == "YouTube"){
            self.TwitchPlayer.isHidden = true
            self.YouTubePlayer.isHidden = false
            YouTubePlayer.load(withVideoId: tempvideo.channel)
            
        }
        
        if(tempvideo.chatroomembedded != "" && tempvideo.chatroomembedded != nil){
            print(tempvideo.chatroomembedded)
            let url = tempvideo.chatroomembedded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            print(url)
            let chaturl = NSURL(string: url ?? "https://www.youtube.com")
            let chatrequest = NSURLRequest(url: chaturl! as URL)
            
            chatroom.load(chatrequest as URLRequest)
        }
        self.TotalVideoPlayer.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
        self.TotalVideoPlayer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapPlayView)))
        //為totalvideplayer添加手勢動作
        // follow button
        self.follow.isHidden = false
        self.follow.setImage(UIImage.init(named: "emptystar"), for: .normal)
        issecond = false
       for i in ilivenetUser.follow{
           if (i == tempvideo.videourl){
            self.follow.setImage(UIImage.init(named: "star3"), for: .normal)
            issecond = true
            break
           }
       }
        
    }
    
    @objc func GetStartTime(noti:Notification) {
        startTime = noti.userInfo!["StartTime"] as! Date
        print(Int(startTime.timeIntervalSince1970))
    }
  
    
    func animate()  {
        switch self.state {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, animations: {
                self.minimizeButton.alpha = 1
                //self.tableView.alpha = 1
                self.TotalVideoPlayer.transform = CGAffineTransform.identity
                //self.YoutubePlayeView.transform = CGAffineTransform.identity
                self.delegate?.setPreferStatusBarHidden(true)
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.delegate?.setPreferStatusBarHidden(false)
                self.minimizeButton.alpha = 0
                //self.tableView.alpha = 0
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.TotalVideoPlayer.bounds.width/4, y: -self.TotalVideoPlayer.bounds.height/2))
                let trasform2 = scale.concatenating(CGAffineTransform.init(translationX: -self.TotalVideoPlayer.bounds.width/4, y: -self.TotalVideoPlayer.bounds.height/2))

                self.TotalVideoPlayer.transform = trasform
                //self.YoutubePlayeView.transform = trasform2
            })
        default: break
        }
    }
    
    func changeValues(scaleFactor: CGFloat) {
        self.minimizeButton.alpha = 1 - scaleFactor
        let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
        let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.TotalVideoPlayer.bounds.width / 4 * scaleFactor), y: -(self.TotalVideoPlayer.bounds.height / 4 * scaleFactor)))
         let trasform2 = scale.concatenating(CGAffineTransform.init(translationX: -(self.TotalVideoPlayer.bounds.width / 4 * scaleFactor), y: -(self.TotalVideoPlayer.bounds.height / 4 * scaleFactor)))
        self.TotalVideoPlayer.transform = trasform
        //轉換TotalVideoPlayer 大小 位置
    }
    
    @objc func HidePlyerView(notification: NSNotification) {
        self.isHidden = true

    }
    @objc func ShowPlayerView(notification: NSNotification){
        self.isHidden = false
        
        
    }
    @objc func tapPlayView()  {
        self.isHidden = false
        customization()
        self.state = .fullScreen
        self.delegate?.didmaximize()
        self.animate()
    }
    //MARK:minimize
    @IBAction func minimize(_ sender: UIButton) {
        let endTime:Date = Date()
        let duration = Int(endTime.timeIntervalSince1970)-Int(startTime.timeIntervalSince1970)
        let myhistory:history = history(video:tempvideo,videourl: tempvideo.id, starttime: startTime,endtime:endTime,duration:duration )
      
        ilivenetUser.history?.append(myhistory)
        let index:Int = tempvideo.category
        
        ilivenetUser.statistics.categorytime[index]!+=duration
        ilivenetUser.statistics.platformtime[tempvideo.platform]!+=duration
        
        if(ilivenetUser.history[0].videourl == ""){
            ilivenetUser.history.remove(at: 0)
            //移調初始化的空白data
        }
        self.follow.isHidden = true
        fsdelastic.InitElastic()
        writeuserdata()
        self.backgroundColor = UIColor.clear
        self.state = .minimized
        self.delegate?.didMinimize()
        self.animate()
    }
    //手勢
    @IBAction func minimizeGesture(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
              
                self.direction = .up
            } else {
               
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.changeValues(scaleFactor: factor)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
        case .minimized:
            if self.direction == .left {
           
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.changeValues(scaleFactor: factor)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
            }
        default: break
        }
        if sender.state == .ended {
            self.state = finalState
            self.animate()
            self.delegate?.didEndedSwipe(toState: self.state)
            if self.state == .hidden {
              
                //self.videoPlayer.pause()
            }
        }
    }
    
    //MARK: Delegate & dataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.video?.suggestedVideos.count {
            return count + 1
        }
        return 0
    }
    
    //MARK: 推薦videos
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header") as! headerCell
            cell.title.text = self.video!.title
            cell.viewCount.text = "\(self.video!.views) views"
            cell.likes.text = String(self.video!.likes)
            cell.disLikes.text = String(self.video!.disLikes)
            cell.channelTitle.text = self.video!.channel.name
            cell.channelPic.image = self.video!.channel.image
            cell.channelPic.layer.cornerRadius = 25
            cell.channelPic.clipsToBounds = true
            cell.channelSubscribers.text = "\(self.video!.channel.subscribers) subscribers"
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! videoCell
            cell.name.text = self.video.suggestedVideos[indexPath.row - 1].channelName
            cell.title.text = self.video.suggestedVideos[indexPath.row - 1].title
            cell.tumbnail.image = self.video.suggestedVideos[indexPath.row - 1].thumbnail
            return cell
        }
    }
    
    //MARK: View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayView), name: NSNotification.Name("open"), object: nil)
        self.customization()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

class headerCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var disLikes: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelPic: UIImageView!
    @IBOutlet weak var channelSubscribers: UILabel!
}

class videoCell: UITableViewCell {
    
    @IBOutlet weak var tumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var name: UILabel!
}
