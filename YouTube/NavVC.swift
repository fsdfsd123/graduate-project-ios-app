
import UIKit
import Firebase


import ElasticSwift
import ElasticSwiftCodableUtils
import ElasticSwiftCore
import ElasticSwiftQueryDSL
import ElasticSwiftNetworking
import NotificationBannerSwift
import NotificationCenter
import Alamofire
class NavVC: UINavigationController, PlayerVCDelegate  {
    
    //MARK: Properties
    @IBOutlet var playerView: PlayerView!
    @IBOutlet var searchView: SearchView!
    @IBOutlet var settingsView: SettingsView!
    //lazy var  initalVC = PageViewVC()
    //隱藏videoview 的 cgpoint
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    //最小化 videoview 的cgpoint
    let minimizedOrigin: CGPoint = {
        let x = UIScreen.main.bounds.width/2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    //全屏幕
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)
    
    //Methods
    func customization() {
        
        self.view.reloadInputViews()
        print("fsduser\(ilivenetUser)")
        print(self.navigationController?.navigationBar.frame.size.height)
        //sidebar 跳轉到各個頁面的notification 接收器
        let notificationName = Notification.Name("getPlatformIndex")
        NotificationCenter.default.addObserver(self, selector: #selector(getPlatformIndex(noti:)), name: notificationName, object: nil)//接受expandeTableview 傳來的platformindex的值，並在getplatformIndex的function中跳轉到對應的頁面
        let notificationName2 = Notification.Name("TurntoPageView")
        NotificationCenter.default.addObserver(self, selector: #selector(TurntoPageView(noti:)), name: notificationName2, object: nil)//接受expandeTableview 傳來的TurntoPageView的值，並在TurntoPageView的function中跳轉到對應的頁面
        
         NotificationCenter.default.addObserver(self, selector: #selector(PresentHomePage(notification:)), name: NSNotification.Name(rawValue: "PresentHomePage"), object: nil)
        
          NotificationCenter.default.addObserver(self, selector: #selector(PresentHistory(notification:)), name: NSNotification.Name(rawValue: "PresentHistory"), object: nil)
        

        
        NotificationCenter.default.addObserver(self, selector: #selector(Search(notification:)), name: NSNotification.Name(rawValue: "Search"), object: nil)

        
        //NavigationBar buttons 去掉標題，並把顏色改為白色
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationBar.topItem?.backBarButtonItem = item
        self.navigationBar.topItem?.backBarButtonItem?.tintColor = .white
        

        
        //Settings Button 跳出setting view 的button
        let settingsButton = UIButton.init(type: .system)
        settingsButton.setImage(UIImage.init(named: "navSettings"), for: .normal)
        settingsButton.tintColor = UIColor.white
        settingsButton.addTarget(self, action: #selector(self.showSettings), for: UIControl.Event.touchUpInside)
        self.navigationBar.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: self.navigationBar, attribute: .height, relatedBy: .equal, toItem: settingsButton, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: settingsButton, attribute: .width, relatedBy: .equal, toItem: settingsButton, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: self.navigationBar, attribute: .centerY, relatedBy: .equal, toItem: settingsButton, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: self.navigationBar, attribute: .right, relatedBy: .equal, toItem: settingsButton, attribute: .right, multiplier: 1.0, constant: 10).isActive = true
        settingsButton.isHidden = true
        //SearchButton
        let searchButton = UIButton.init(type: .system)
        searchButton.setImage(UIImage.init(named: "navSearch"), for: .normal)
        searchButton.tintColor = UIColor.white
        searchButton.addTarget(self, action: #selector(self.showSearch), for: UIControl.Event.touchUpInside)
        self.navigationBar.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: self.navigationBar, attribute: .height, relatedBy: .equal, toItem: searchButton, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: searchButton, attribute: .width, relatedBy: .equal, toItem: searchButton, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: self.navigationBar, attribute: .centerY, relatedBy: .equal, toItem: searchButton, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: searchButton, attribute: .right, relatedBy: .equal, toItem: settingsButton, attribute: .right, multiplier: 1.0, constant: 20).isActive = true

        

        //NavigationBar color and shadow
        self.navigationBar.barTintColor = UIColor.rbg(r: 109, g: 109, b: 109)
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationItem.hidesBackButton = true
        
        //SearchView setup 還不確定要放什麼
        self.view.addSubview(self.searchView)
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        guard let v = self.view else { return }
        let _ = NSLayoutConstraint.init(item: v, attribute: .top, relatedBy: .equal, toItem: self.searchView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: v, attribute: .left, relatedBy: .equal, toItem: self.searchView, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: v, attribute: .right, relatedBy: .equal, toItem: self.searchView, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: v, attribute: .bottom, relatedBy: .equal, toItem: self.searchView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        self.searchView.isHidden = true
      
        //SettingsView setup
        self.view.addSubview(self.settingsView)
        self.settingsView.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: v, attribute: .top, relatedBy: .equal, toItem: self.settingsView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: v, attribute: .left, relatedBy: .equal, toItem: self.settingsView, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: v, attribute: .right, relatedBy: .equal, toItem: self.settingsView, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: v, attribute: .bottom, relatedBy: .equal, toItem: self.settingsView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        self.settingsView.isHidden = true
        
        //PLayerView setup
        self.playerView.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        self.playerView.delegate = self
        
        //self.navigationController?.pushViewController(initalVC, animated: true)
    }
    
    @objc func showSearch()  {
        self.searchView.alpha = 0
        self.searchView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.searchView.alpha = 1
        }) { _ in
            self.searchView.inputField.becomeFirstResponder()
        }
    }
    
    @objc func showSettings() {
        self.settingsView.isHidden = false
        self.settingsView.tableViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) { 
            self.settingsView.backgroundView.alpha = 0.5
            self.settingsView.layoutIfNeeded()
        }
    }
    

    
    @objc func getPlatformIndex(noti:Notification) {
        tempvc = "platform"
        platformpage = noti.userInfo!["PlatformIndex"] as! Int
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlatformVC") as! PlatformVC
        self.popToRootViewController(animated: true)
        
        self.pushViewController(vc, animated: true)
    }
    // MARK: TurntoPageView
    @objc func TurntoPageView(noti:Notification) {
        tempvc = "category"
        print("TurntoPageView")
        //var Methord = noti.userInfo!["TurntoPageView"] as! String
        let vc = storyboard?.instantiateViewController(withIdentifier: "PageViewVC") as! PageViewVC
        //vc.Methord = "platform"
        self.popToRootViewController(animated: true)
              
        self.pushViewController(vc, animated: true)
    }
    
    @objc func PresentHomePage(notification: NSNotification) {
        
        tempvc = "homepage"
        platformpage = notification.userInfo!["PresentHomePage"] as! Int
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
        self.popViewController(animated: true)
        self.pushViewController(vc, animated: true)
    }
    
    @objc func PresentHistory(notification: NSNotification) {
        var vctype = notification.userInfo!["PresentHistory"] as! String
        let vc = storyboard?.instantiateViewController(withIdentifier: "HistoryTableViewController") as! HistoryTableViewController
        //vc.IsHistroy = true
        vc.navigationItem.title = vctype
        vc.vctype = vctype
        self.popViewController(animated: true)
        self.pushViewController(vc, animated: true)
    }
    
    @objc func Search(notification: NSNotification) {

        print("reload")
        var controller1 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
   
        controller1?.truevideo = [FsdVideo]()
        controller1?.Value = totalsearch
        controller1?.Methord = "?q"
        print(controller1?.Value)
        controller1?.from = 0
        controller1?.reloadApi()
        print("fsd search api\((controller1?.Api)!)")
        let controller0 = UIViewController()
        self.popViewController(animated: true)
        
        self.pushViewController(controller1 ?? controller0, animated: true)
        
        controller1?.navigationItem.title = "Search"
        
        print("finsh")
        

    }
    
  
    func animatePlayView(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.beginFromCurrentState], animations: {
                self.playerView.frame.origin = self.fullScreenOrigin
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.minimizedOrigin
            })
        case .hidden:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.hiddenOrigin
            })
        }
    }
    
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
    
    //MARK: Delegate methods
    
    
    func didMinimize() {
        self.animatePlayView(toState: .minimized)
    }
    
    func didmaximize(){
        self.animatePlayView(toState: .fullScreen)
    }
    
    func didEndedSwipe(toState: stateOfVC){
        self.animatePlayView(toState: toState)
    }
    
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC){
        switch toState {
        case .fullScreen:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        case .hidden:
            self.playerView.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
        case .minimized:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        }
    }
    
    func setPreferStatusBarHidden(_ preferHidden: Bool) {
        self.isHidden = preferHidden
    }
    
    var isHidden = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.view.reloadInputViews()
        var notificationName = Notification.Name("PresentHomePage")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PresentHomePage":0])
        //self.pushViewController(HomePageVC(), animated: true)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PresentHomePage":0])
//        notificationName = Notification.Name("TurntoPageView")
//        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["TurntoPageView":"Category"])
     
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.playerView)
        }
        whileloop()
    }
    
    @objc func threadPrint(){
        let database: DatabaseReference = Database.database().reference()
        //database.child("users").child(ilivenetUser.uid).setValue(ilivenetUser.convertToDict())
        let appRef = database.child("users").child(Auth.auth().currentUser?.uid ?? "hLO3XFmTeOb0jQU3WEhztX3kDHh2").child("recommendlist")
   
        appRef.observe(.childChanged, with: { (snapshot) -> Void in
            print("fsd firebse change")
            self.RFMnotification()
            //self.comments.append(snapshot)
          //self.tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: self.kSectionComments)], with: UITableViewRowAnimation.automatic)
        })
        
        
    }
    func whileloop(){
       Thread.detachNewThreadSelector(#selector(threadPrint), toTarget: self, with: nil)
    }
    func RFMnotification(){
        let banner = NotificationBanner(title: "There are some recommended livestreams for you")
        banner.show()
        banner.onTap = {
                    print("banner is taped")
                    //MARK: COUNT PLATFORM TIMES
                    tempvideo = signalrecommendlive
                    print("tempvideo.platform:\(tempvideo.platform)")
                    print("tempvideo.category:\(tempvideo.category)")
                    let title = ["Twitch", "YouTube", "liveme", "17直播", "西瓜直播","kingkong"]
                    var judge:Bool = false
                    for i in title{
                        if(tempvideo.platform==i){
                            judge = true
                        }
                    }
                    print("statistics:\(ilivenetUser.statistics)")
                    if(judge){
                        //print(ilivenetUser.statistics.platformcount)
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
            //        case "YouTube":
            //            ilivenetUser.statistics.platform.YouTube+=1
            //        case "Facebook":
            //            ilivenetUser.statistics.platform.liveme+=1
            //        case "17直播":
            //            ilivenetUser.statistics.platform.Live17+=1
            //        case "西瓜直播":
            //            ilivenetUser.statistics.platform.Xigua+=1
            //
            //        default:
            //            print("none")
            //        }
                    print("tempvideo.category\(tempvideo.category)")
                  
                 
                    Alamofire.request("\(ipaddress)update_click_through?videourl=\(tempvideo.videourl)")
                    //向伺服器回傳哪部影片被點擊
                    
                    let starttime:Date = Date()//記錄點擊影片的瞬間
                    let notificationName = Notification.Name("GetStartTime")
                    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["StartTime":starttime])
                    //向playerview或者webview呼叫計時的func,并傳遞starttime
                    print(type(of: starttime.timeIntervalSince1970))
                    
                    print("webtest2")
                    if(tempvideo.platform == "YouTube" || tempvideo.platform == "Twitch"){
                         print("webtest")
                         NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil)
                        //"youtube" or "twitch" 跳轉到playerview用播放器播放
                    }
                    else{
                 
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoWebView") as! VideoWebView
                        vc.startTime = starttime
                        self.pushViewController(vc, animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name("HidePlyerView"), object: nil)
                        //其他平台未抓到直播源的則直接跳轉到網頁
                    }
                }
            //let notificationName = Notification.Name("PresentHomePage")
            //NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PresentHomePage":2])
        }
    }

  

