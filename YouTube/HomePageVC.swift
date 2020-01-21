

import UIKit
import Firebase
class HomePageVC: UIViewController {
    lazy var controllerArray : [UIViewController] = []
    lazy var controller1 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller2 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller3 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
//    lazy var controller4 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
//    lazy var controller5 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
//    lazy var controller6 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
//    lazy var controller7 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller0 : UIViewController = UIViewController()
    
    @IBAction func MenuButton(sender: AnyObject) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = item
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .white
      
        self.navigationController?.title = "HomePage"
        //NotificationCenter.default.addObserver(self, selector: #selector(loadvc(notification:)), name: NSNotification.Name(rawValue: "loadvc"), object: nil)
        let totop = UIButton(frame: CGRect(x: 40, y: 0, width: 220, height: 44))
        totop.alpha = 1
        totop.addTarget(self, action: #selector(BackToTop), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(totop)
        let titles = ["hot","most_viewed","recommended"]

        print("ilivenetUser.recommendlist\(ilivenetUser.recommendlist)")
        let api = "new_home_page?category=\(ilivenetUser.recommendlist[0]),\(ilivenetUser.recommendlist[1]),\(ilivenetUser.recommendlist[2]),\(ilivenetUser.recommendlist[3])"
        print("home api\(api)")
        controller1?.Api = api
        controller1?.homePageApi = titles[0]
        controller1?.title = titles[0]
        
        controller2?.Api = api
        controller2?.homePageApi = titles[1]
        controller2?.title = titles[1]
        
        controller3?.Api = api
        controller3?.homePageApi = titles[2]
        controller3?.title = titles[2]

        PageView.backgroundColor = UIColor.rbg(r: 109, g: 109, b: 109)
        PageView.tintColor = .white
        PageView.titles = titles
        PageView.viewControllers = [controller1,controller2,controller3] as! [UIViewController]
        
    }
    
    @IBOutlet var PageView: RNScrollPageView!
    
    @objc func BackToTop(){
      
        
        switch self.PageView.currentSelectedIndex {
        case 0:
            
            self.controller1?.test.setContentOffset(.zero, animated:true)
        case 1:
       
            self.controller2?.test.setContentOffset(.zero, animated:true)
        case 2:

            self.controller3?.test.setContentOffset(.zero, animated:true)

            
        default:
            return
        }
        
    }
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
