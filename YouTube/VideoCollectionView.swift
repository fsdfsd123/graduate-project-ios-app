
import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import ActionButton
import GTMRefresh
class test: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    //HomePage 的不同種類
    var hot = [FsdVideo]()
    var most_viewed = [FsdVideo]()
    var feature_one = [FsdVideo]()
    var feature_two = [FsdVideo]()
    var feature_three = [FsdVideo]()
    var feature_four = [FsdVideo]()
 
    
    var homePageApi = "" // 如果為homepage，則判斷homepage的那個種類用的值
   
    //var kindname = ["hot","most_viewed","recommended","subscriptions","today","upcoming","within_72_hours"]
    //homepage的不同種類的名稱字典
    
    //lazy var total :[String:[FsdVideo]] = ["hot":hot,"most_viewed":mostviewed,"recommended":recommended,"subscriptions":subscriptions,"today":today,"upcoming":upcoming,"within_72_hours":within72hours]
    lazy var total :[String:[FsdVideo]] = ["hot":hot,"most_viewed":most_viewed,"feature_one":feature_one,"feature_two":feature_two,"feature_three":feature_three,"feature_four":feature_four]
    //存放不同種類的video的[FsdVideo]
    
    @IBOutlet weak var test: UICollectionView!

    @IBOutlet weak var testlayout: UICollectionViewFlowLayout!
    
    let  fullScreenSize = UIScreen.main.bounds.size
    
    var IsHistroy = false //判斷是否要讀取history videos
    
    var Methord:String = "" //傳遞q或者platform或者其他的參數
    
    var Value:String = "" //Methord 後面跟的值
    

    
    var truevideo = [FsdVideo]() //暫存讀取到的video的陣列
    

    
    var from:Int = 0 // api中的from參數 決定從哪筆開始讀取
    
    var size:Int = 10 // size參數 決定讀取多少筆
    
    var Api :String = "" // 整體的向伺服器回傳的最終api
   
    var currentIsInBottom = false // 判斷collectionview 是否在底部
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(IsHistroy){
            print(ilivenetUser.history)
            print("count-----\(ilivenetUser.history?.count)")
            return ilivenetUser.history?.count ?? 0
            
        }
        else{
            return self.truevideo.count
        }
        //如果是history 則讀取 history 的count,不然讀取truevideo
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"testcell", for: indexPath) as! testcell
        cell.image.sizeThatFits(CGSize(width: fullScreenSize.width/2-10, height: 130))
        
        if(IsHistroy){
           
                cell.testcelllabel.text = ilivenetUser.history?[indexPath.row].video.title
                let url = URL(string:ilivenetUser.history?[indexPath.row].video.thumbnails ?? "")
                cell.image.kf.setImage(with: url)
            
        }
        else{
            var platformlogo = UIImageView(
                frame: CGRect(
                    x: 5, y: 5, width: 20, height: 20))
            
            platformlogo.image = UIImage(named: "\(truevideo[indexPath.row].platform).png")
            cell.image.addSubview(platformlogo)
            //左上角表示videoplatform的標誌
            
//            var visitlogo = UIImageView(
//                frame: CGRect(
//                    x: cell.image.frame.width, y: 5, width: 15, height: 15))
//
//            visitlogo.image = UIImage(named: "peoplelogo.png")
            //cell.image.addSubview(visitlogo)
            //visit logo
            
            let viewers = UILabel(frame: CGRect(x: cell.image.frame.width-5, y: 5, width: 30, height: 15))
            viewers.text = "\(truevideo[indexPath.row].viewers)"
            viewers.textColor = .yellow
            viewers.font = UIFont.systemFont(ofSize: 10)
            //右上角顯示觀看數目的數字
            
            cell.image.addSubview(viewers)// 背景圖
            
            cell.testcelllabel.text = (truevideo[indexPath.row].title)//標題
            cell.testcelllabel.textColor = .white
            let url = URL(string:truevideo[indexPath.row].thumbnails)
            cell.image.kf.setImage(with: url)
        }
        
        if(self.currentIsInBottom){
      
            self.from = self.from + size
            fetchdata(Api: self.Api)
            self.currentIsInBottom = false
            //如果已經滑動到底部，則再讀取size筆數據
        }
        return cell
    }
    
//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//
//    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //tempvideo:user目前選擇的video
        
        if(IsHistroy){
            tempvideo = ilivenetUser.history?[indexPath.row].video ?? FsdVideo()
        }
        else{
            tempvideo = truevideo[indexPath.row]
        }
        //print(tempvideo.platform)
        //MARK: COUNT PLATFORM TIMES
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
     
            let vc = storyboard?.instantiateViewController(withIdentifier: "VideoWebView") as! VideoWebView
            vc.startTime = starttime
            self.navigationController?.pushViewController(vc, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("HidePlyerView"), object: nil)
            //其他平台未抓到直播源的則直接跳轉到網頁
        }
    }

    func reloadApi(){
        //get_category_streams?category=101&from=0&size=1&language=en
        self.Api = "\(self.Methord)=\(self.Value)&from=\(self.from)&size=\(self.size)&language=\(language)"
        print("final api: \(self.Api)")
        //讀取api的參數后重新載入整個api
    }
    
    //上下滑動刷新的func
    func refresh() {
        perform(#selector(endRefresing), with: nil, afterDelay: 3)
    }
    
    @objc func endRefresing() {
        if(homePageApi != ""){
            self.fetchdata(Api: self.Api)
        }
        else{
            self.fetchHomePagedata(Api: self.Api)
        }
        self.test.reloadData()
        self.test.endRefreshing(isSuccess: true)
    }
    func loadMore() {
        perform(#selector(endLoadMore), with: nil, afterDelay: 3)
    }
    
    @objc func endLoadMore() {
        self.test.endLoadMore(isNoMoreData: true)
    }
    //上下滑動刷新的func
//    @objc func loading(){
//        self.showSpinner(onView: self.view)
//    }
//    @objc func endloading(){
//        self.showSpinner(onView: self.view)
//    }
    override func viewDidLoad() {
      
        self.test.backgroundColor = UIColor.rbg(r: 80, g: 80, b: 80)
        //Thread.detachNewThreadSelector(#selector(loading), toTarget: self, with: nil)
        self.showSpinner(onView: self.view)
        //var myactivity:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:.gray)
        //myactivity.startAnimating()
        //self.view.addSubview(myactivity)
        print("fsd homepageapi\(self.homePageApi)")
        //上下滑動刷新的func
        self.test.gtm_addRefreshHeaderView {
            [weak self] in
            print("excute refreshBlock")
            self?.refresh()
        }
        
        self.test.gtm_addLoadMoreFooterView {
            [weak self] in
            print("excute loadMoreBlock")
            self?.loadMore()
        }
        self.test.pullDownToRefreshText("refresh")
            .releaseToRefreshText("refresh")
            .refreshSuccessText("refresh")
            .refreshFailureText("refresh")
            .refreshingText("refresh")

        // color
        self.test.headerTextColor(.red)
       //上下滑動刷新的func
        

        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem? = item
        
        //if(Api == "new_home_page?category=\(ilivenetUser.recommendlist[0]),\(ilivenetUser.recommendlist[1]),\(ilivenetUser.recommendlist[2]),\(ilivenetUser.recommendlist[3])"){
        if(homePageApi != ""){
            fetchHomePagedata(Api: self.Api)
        }
        else{
            self.reloadApi()
            fetchdata(Api: self.Api)
        }
        self.removeSpinner()
        self.test.delegate = self;
        self.test.dataSource = self;
        testlayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        testlayout.itemSize = CGSize(width: fullScreenSize.width/2-10, height: 150)
        testlayout.minimumLineSpacing = 5
        testlayout.minimumLineSpacing = 5
        testlayout.scrollDirection = .vertical
        testlayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 5)
        
      
        print("has remove")
        super.viewDidLoad()
        //self.removeSpinner()
        //myactivity.stopAnimating()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        //self.showSpinner(onView: self.view)
        super.viewDidAppear(animated)
        self.removeSpinner()
        //self.removeSpinner()
    }
    override  func viewDidAppear(_ animated: Bool) {
        //self.removeSpinner()
    }
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
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
   
    
    //fetchdata抓取?q或者？platform的data
    func fetchdata(Api:String){
        
        let url = "\(ipaddress)\(Api)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        //生成url
        //用alamofire發送request
        Alamofire.request(url).responseJSON(completionHandler: { response in
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
          
                if let result = json["hits"]["hits"].array{
                 
                    //print(SearchResult)
                    print(result.count)
                    var channel_list : [String] = []
                    var video = [testvideo()]
                    var SearchVideo = [FsdVideo()]

                    if json["hits"]["hits"].isEmpty{
                        
                        print("error")
                        //self.test.isHidden = true
                        self.Methord = "q"
                        self.reloadApi()
                        self.fetchdata(Api: self.Api)
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
                        let channel = json["hits"]["hits"][i]["_source"]["channel"].string
                        let id = json["hits"]["hits"][i]["_id"].string
                        let index = json["hits"]["hits"][i]["_index"].string
                        let score = json["hits"]["hits"][i]["_score"].double
                        let type = json["hits"]["hits"][i]["_type"].string
                        let category =  json["hits"]["hits"][i]["_source"]["category"].int
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
                        self.truevideo.append(FsdVideo(id: id ?? "", index: index ?? "", score: score ??  0, type: type ?? "", category:category ?? 0,chatroomembedded: chatroomembedded ?? "", language: language ?? "", status: status ?? "", title: title ?? "", host: host ?? "", tags: tags ?? "", videoid: videoid ?? "", videourl: videourl ?? "", popular_rate: popular_rate ?? 0, channel: channel ?? "", generaltag: generaltag ?? "", viewers: viewers ?? 0, click_through: click_through ?? 0, platform: platform ?? "", videoembedded: videoembedded ?? "", viewcount: viewcount ?? 0, published: published ?? "", thumbnails: thumbnails ?? "", description: description ?? ""))
                        //講讀取到的json檔的每個值載入到fsdvideo struct 內不同的var 中
                    }
                    self.truevideo.remove(at: 0)//json第一個為空，所以remove
                    self.showSpinner(onView: self.view)
                    self.test.reloadData()//重新刷新collectionview
                    self.removeSpinner()
                }
            }
            else {
                print("error: \(response.error)")
            }
        })
       
    }
    
    //抓取homepage的data json格式不同
    func fetchHomePagedata(Api:String){
        Alamofire.request("\(ipaddress)\(Api)").responseJSON(completionHandler: { response in
            if response.result.isSuccess {
                var json:JSON = []
                do {
                    json = try JSON(data: response.data!)
                    
                } catch {
                }
                if(json.isEmpty){
                    return
                }
                let kind = self.total.keys
                
                //將video分別載入到不同kind的[fsdvideo]內
                for j in kind{
                    if let result = json[j].array{
                        var channel_list : [String] = []
                        var video = [testvideo()]
                        for i in 0...result.count-1{
                            
                            let channel = json[j][i]["_source"]["channel"].string
                            let id = json[j][i]["_id"].string
                            let index = json[j][i]["_index"].string
                            let score = json[j][i]["_score"].double
                            let type = json[j][i]["_type"].string
                            let category =  json[j][i]["_source"]["category"].int
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
                       
                            self.total[j]?.append(FsdVideo(id: id ?? "", index: index ?? "", score: score ??  0, type: type ?? "", category:category ?? 0,chatroomembedded: chatroomembedded ?? "", language: language ?? "", status: status ?? "", title: title ?? "", host: host ?? "", tags: tags ?? "", videoid: videoid ?? "", videourl: videourl ?? "", popular_rate: popular_rate ?? 0, channel: channel ?? "", generaltag: generaltag ?? "", viewers: viewers ?? 0, click_through: click_through ?? 0, platform: platform ?? "", videoembedded: videoembedded ?? "", viewcount: viewcount ?? 0, published: published ?? "", thumbnails: thumbnails ?? "", description: description ?? ""))
                     
                            print(self.total[j]?[i].platform)
                            print(self.total[j]?[i].channel)
                        }
                        
                    }
                }
                
                //如果homepageapi為哪個，就讓truevideo為哪個
                //print("fsd homepageapi\(self.homePageApi)")
                if(self.homePageApi == "hot"){
                    print("fsd homepageapi2\(self.homePageApi)")
                    self.truevideo = self.total["hot"] ?? [FsdVideo()]
                }
                if(self.homePageApi == "most_viewed"){
                    print("fsd homepageapi2\(self.homePageApi)")
                    self.truevideo = self.total["most_viewed"] ?? [FsdVideo()]
                }
                
                if(self.homePageApi == "recommended"){
                    print("fsdrecommendlist\(ilivenetUser.recommendlist)")
                    //self.truevideo = self.total["recommended"] ?? [FsdVideo()]
                    print("fsd homepageapi2\(self.homePageApi)")
                    print("feature one \(self.total["feature_one"])")
                    self.truevideo = self.total["feature_one"] ?? [FsdVideo()]
                    for i in self.total["feature_two"] ?? [FsdVideo()]{
                        self.truevideo.append(i)
                    }
                    for i in self.total["feature_three"] ?? [FsdVideo()]{
                        self.truevideo.append(i)
                    }
                    for i in self.total["feature_four"] ?? [FsdVideo()]{
                        self.truevideo.append(i)
                    }
                    //self.truevideo.append(contentsOf: self.total["feature_two"] ?? [FsdVideo()])
                    //self.truevideo.append(contentsOf: self.total["feature_three"] ?? [FsdVideo()])
                    //self.truevideo.append(contentsOf: self.total["feature_four"] ?? [FsdVideo()])
                    
                    print("--------")
                    for i in self.total["feature_one"] ?? [FsdVideo()]{
                        print(i.id)
                        print(",")
                    }
                    for i in self.total["feature_two"] ?? [FsdVideo()]{
                        print(i.id)
                        print(",")
                    }
                    for i in self.total["feature_three"] ?? [FsdVideo()]{
                        print(i.id)
                        print(",")
                    }
                    //print(self.total["feature_four"])
                    for i in self.total["feature_four"] ?? [FsdVideo()]{
                        print(i.id)
                        print(",")
                    }
                    print("---------")
                    for i in self.truevideo{
                        print("\(i.id)/n")
                    }
                    //print(self.truevideo)
                }
                signalrecommendlive = self.total["feature_one"]?[0] ?? FsdVideo()
                self.test.reloadData()
            }
            else {
                print("error: \(response.error)")
            }
        })
    }
    
    
  
    
}

