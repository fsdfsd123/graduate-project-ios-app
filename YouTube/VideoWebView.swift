//
//  webView.swift
//  YouTube
//
//  Created by csie on 2019/7/17.
//  Copyright © 2019 Haik Aslanyan. All rights reserved.
//

import UIKit
import WebKit
import Firebase
class VideoWebView:UIViewController {
    
    //@IBOutlet var follow: UIBarButtonItem!
    @IBOutlet var VideoWeb: WKWebView!
    var startTime:Date!
    var settingsButton = UIButton.init(type: .system)
    var issecond = false
    override func viewDidLoad() {
        
        let url = NSURL(string: tempvideo.videourl ?? "http:www.youtube.com")
        let request = NSURLRequest(url: url! as URL)
        VideoWeb.load(request as URLRequest)
        //load web
        self.settingsButton.isHidden = false
        //settingsButton.fram.size
        
        settingsButton.setImage(UIImage.init(named: "emptystar"), for: .normal)
        for i in ilivenetUser.follow{
            if (i == tempvideo.videourl){
                settingsButton.setImage(UIImage.init(named: "star3"), for: .normal)
                issecond = true
                break
            }
        }
        
        //settingsButton.backgroundColor = UIColor.rbg(r: 109, g: 109, b: 109)
        //settingsButton.titleLabel?.text = "follow"
               settingsButton.tintColor = UIColor.white
               settingsButton.addTarget(self, action: #selector(self.followaction), for: UIControl.Event.touchUpInside)
        self.navigationController?.navigationBar.addSubview(settingsButton)
               settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let _ = NSLayoutConstraint.init(item: self.navigationController?.navigationBar, attribute: .height, relatedBy: .equal, toItem: settingsButton, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
               let _ = NSLayoutConstraint.init(item: settingsButton, attribute: .width, relatedBy: .equal, toItem: settingsButton, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: self.navigationController?.navigationBar, attribute: .centerY, relatedBy: .equal, toItem: settingsButton, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: self.navigationController?.navigationBar, attribute: .right, relatedBy: .equal, toItem: settingsButton, attribute: .right, multiplier: 1.0, constant: 30).isActive = true
               
        //settingsButton.setImage(UIImage.init(named: "navSettings"), for: .normal)
     
    }
   
    @objc func followaction(_ sender: Any) {
        print("follow")
        if(issecond){
            
            settingsButton.setImage(UIImage.init(named: "emptystar"), for: .normal)
           
            for i in 0...ilivenetUser.follow.count-1{
                print("fsd test \(i)")
                if (ilivenetUser.follow[i] == tempvideo.videourl){
                      if(ilivenetUser.follow.count == 1){
                            ilivenetUser.follow.remove(at: i)
                            ilivenetUser.follow.append("")
                            
                        }
                        else{
                            ilivenetUser.follow.remove(at: i)
                            break
                        }
                }
            }
            issecond = false
        }
        else{
            
            settingsButton.setImage(UIImage.init(named: "star3"), for: .normal)
            ilivenetUser.follow.append(tempvideo.videourl)
//            for i in 0...ilivenetUser.follow.count-1{
//                if(ilivenetUser.follow[i] == tempvideo.videourl){
//                    ilivenetUser.follow.remove(at: i)
//                }
//            }
           
            issecond = true
        }
        


        let database: DatabaseReference = Database.database().reference()
        database.child("users").child(Auth.auth().currentUser?.uid ?? "hLO3XFmTeOb0jQU3WEhztX3kDHh2").child("follow").setValue(ilivenetUser.follow)
        let notificationName = Notification.Name("reloadfollow")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["reloadhistory":"reload"])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.settingsButton.isHidden = true
        //nav back到上一層後的動作
        if isMovingFromParentViewController {
            let endTime:Date = Date()
            let duration = Int(endTime.timeIntervalSince1970)-Int(startTime.timeIntervalSince1970)
            let myhistory:history = history(video:tempvideo,videourl: tempvideo.videourl, starttime: startTime,endtime:endTime,duration:duration )
            
            ilivenetUser.history?.append(myhistory)
            if(ilivenetUser.history[0].videourl == ""){
                ilivenetUser.history.remove(at: 0)
            }
            
            let index:Int = tempvideo.category
            ilivenetUser.statistics.categorytime[index]!+=duration
            ilivenetUser.statistics.platformtime[tempvideo.platform]!+=duration
            writeuserdata()
            fsdelastic.InitElastic()
            NotificationCenter.default.post(name: NSNotification.Name("ShowPlayerView"), object: nil)
        }
        
    }

}
