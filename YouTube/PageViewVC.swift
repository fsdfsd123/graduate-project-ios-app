
import UIKit

import SidebarOverlay
import NotificationBannerSwift
class PageViewVC: UIViewController {
    
    @IBAction func MenuButton(sender: AnyObject) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    //get_category_streams?category=101&from=0&size=1&language=en
    var Methord = "get_category_streams?category"
    //var Tagdict = ["Twitch":1,"YouTube":2, "liveme":3, "17":4,"西瓜直播":5]
    //var TagList = ["Twitch", "YouTube", "FaceBook", "17live", "西瓜直播"]
    let Tagdict=[
        "GAME":100,
        "射擊":101,
        "MMORPG":102,
        "RPG":103,
        "FPS":105,
        "運動遊戲":106,
        "卡牌與桌遊":108,
        "平台遊戲":109,
        "恐怖":117,
        "益智":119,
        "動作":120,
        "策略":125,
        "開放世界":126,
        "節奏與音樂遊戲":127,
        "IRL生活實況":137,
        "MOBA":138,
        "談話節目":300,
        "新聞":400,
        "其它":590,
        "運動":700,
        "科技":900,
        "動物星球":1000,
        "未分類":0
    ]
    @IBOutlet weak var pageView: RNScrollPageView!
    lazy var controllerDict = [String:test]()
    lazy var searviewcontroller = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var nav = UINavigationController()
    lazy var controller0 : UIViewController = UIViewController()

    

    override func viewDidLoad() {
        
        //self.showSpinner(onView: self.view)
        super.viewDidLoad()
        
        //print("fsd banner: \(banner.dismiss())")
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
           self.navigationController?.navigationBar.topItem?.backBarButtonItem = item
           self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .white
            
        let totop = UIButton(frame: CGRect(x: 40, y: 0, width: 220, height: 44))
 
        totop.alpha = 1
        totop.addTarget(self, action: #selector(BackToTop), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(totop)
        
        pageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height)
        
       
       
        //var buffer = [test](controllerDict.values)
        for i in Tagdict.keys{
            print(i)
            controllerDict[i] = storyboard?.instantiateViewController(withIdentifier: "test") as? test
        }
        for i in controllerDict{
            i.value.Methord = self.Methord
            if(self.Methord == "platform"){
                i.value.Value = i.key
                print("i.key:\(i.key)")
            }
            if(self.Methord == "get_category_streams?category"){
                i.value.Methord = self.Methord
                print("i.keys\(i.key)")
                print("i.keys.int\(Tagdict[i.key])")
                if let result = Tagdict[i.key]as? Int {

                    let result = String(result)
                     i.value.Value = result
                }
               
            }
            
            i.value.title = i.key
            print(i)
            self.pageView.titles.append(i.key)
        }
        
        var buffer = [String](Tagdict.keys)
        print(buffer)
        var buffer2 = [test]()
        for i in Tagdict.keys{
            buffer2.append(controllerDict[i] ?? controller0 as! test)
        }
        //self.pageView.titles =  [String](Tagdict.keys)
        //self.pageView.viewControllers = [test](controllerDict.values)
        self.pageView.viewControllers = buffer2
        //self.removeSpinner()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func Search(notification: NSNotification) {
        print("reload")
        var controller1 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    
        controller1?.truevideo = [FsdVideo]()
        controller1?.Value = totalsearch
        controller1?.Methord = "q"
        print(controller1?.Value)
        controller1?.from = 0
        controller1?.reloadApi()
        print(controller1?.Api)

    
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = item
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .white
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.pushViewController(searviewcontroller ?? controller0, animated: true)
        searviewcontroller?.navigationItem.title = "search"
        print("finsh")

       
    }
    
    @objc func BackToTop(){
        var buffer = [String](Tagdict.keys)
        print(self.pageView.currentSelectedIndex)
        print(buffer)
        //print(buffer[self.pageView.currentSelectedIndex])
        var title = self.pageView.viewControllers[self.pageView.currentSelectedIndex].title as! String
        self.controllerDict[title]?.test.setContentOffset(.zero, animated:true)
        //print(buffer.index(after: ))
        
        //print(Tagdict.keys[])
        //self.controllerDict[buffer[self.pageView.currentSelectedIndex]]?.test.setContentOffset(.zero, animated:true)
      
    }


}

