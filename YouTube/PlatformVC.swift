
import UIKit

import SidebarOverlay
class PlatformVC: UIViewController {
    
    @IBAction func MenuButton(sender: AnyObject) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    
    
    @IBOutlet weak var pageView: RNScrollPageView!
    lazy var controllerArray : [UIViewController] = []
    lazy var nav = UINavigationController()
   
    lazy var controller2 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller3 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller4 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller5 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller6 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller7 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller0 : UIViewController = UIViewController()
    

    override func viewDidLoad() {
        print("fsd2 user\(ilivenetUser)")
        super.viewDidLoad()
       
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = item
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .white
      
        let totop = UIButton(frame: CGRect(x: 40, y: 0, width: 220, height: 44))
 
        totop.alpha = 1
        totop.addTarget(self, action: #selector(BackToTop), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(totop)
        
        pageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height)
        pageView.backgroundColor = UIColor.rbg(r: 109, g: 109, b: 109)
        pageView.tintColor = .white
        let titles = ["Twitch", "YouTube", "liveme", "17直播", "西瓜直播","kingkong"]
     

        controller2?.Methord = "?platform"
        controller2?.Value = "Twitch"
        controller2?.title = "Twitch"
        controllerArray.append(controller2 ?? controller0)
        
        
        
      
        controller3?.Methord = "?platform"
        controller3?.Value = "YouTube"
        controller3?.title = "YouTube"
        controllerArray.append(controller3 ?? controller0)
        
        
        
        controller4?.Methord = "?platform"
        controller4?.Value = "liveme"
        controller4?.title = "liveme"
        controllerArray.append(controller4 ?? controller0)
        
        controller5?.Methord = "?platform"
        controller5?.Value = "17直播"
        controller5?.title = "17直播"
        controllerArray.append(controller5 ?? controller0)
        
        controller6?.Methord = "?platform"
        controller6?.Value = "西瓜"
        controller6?.title = "西瓜直播"
        controllerArray.append(controller6 ?? controller0)
        
        controller7?.Methord = "?platform"
        controller7?.Value = "kingkong"
        controller7?.title = "kingkong"
        controllerArray.append(controller7 ?? controller0)

    
        self.pageView.viewControllers = controllerArray
        self.pageView.titles = titles
        
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
        self.navigationController?.pushViewController(controller1 ?? controller0, animated: true)
        controller1?.navigationItem.title = "search"
        print("finsh")

       
    }
    
    @objc func BackToTop(){
        
        switch self.pageView.currentSelectedIndex {
            
        case 0:
     
            self.controller2?.test.setContentOffset(.zero, animated:true)
        case 1:
      
            self.controller3?.test.setContentOffset(.zero, animated:true)
        case 2:
          
            self.controller4?.test.setContentOffset(.zero, animated:true)
        case 3:
         
            self.controller5?.test.setContentOffset(.zero, animated:true)
        case 4:
    
            self.controller6?.test.setContentOffset(.zero, animated:true)
        case 5:
     
            self.controller7?.test.setContentOffset(.zero, animated:true)
        default:
            return
        }

    }


}

