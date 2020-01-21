//
//  HomeVC.swift
//  YouTube
//
//  Created by csie on 2019/7/15.
//  Copyright © 2019 Haik Aslanyan. All rights reserved.
//

import UIKit
import PageMenu
import ActionButton
//for pageview


class HomeVC2: UIViewController, UIScrollViewDelegate{
    var actionButton: ActionButton!
    
    var pageMenu: CAPSPageMenu?
    var searchapi:String = "hi"
    lazy var controllerArray : [UIViewController] = []
    //lazy var controller1 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller2 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller3 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller4 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller5 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller6 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller7 = storyboard?.instantiateViewController(withIdentifier: "test") as? test
    lazy var controller0 : UIViewController = UIViewController()
    
//    lazy var controller2 = storyboard?.instantiateViewController(withIdentifier: "TotalVC") as? TotalVC
//    lazy var controller3 = storyboard?.instantiateViewController(withIdentifier: "TotalVC") as? TotalVC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addActionButton()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.pageMenu?.view.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        setupPageMenu()
        self.view.addSubview(self.pageMenu!.view)
        //NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
//    @objc func loadList(notification: NSNotification) {
//        //self.searchapi = totalsearch
//        //self.view.reloadInputViews()
//        print("reload")
//        //self.controller1?.Api = "?q=\(searchapi)"
//        self.controller1?.truevideo = [FsdVideo]()
//        self.controller1?.Value = totalsearch
//        print(self.controller1?.Value)
//        self.controller1?.from = 0
//        self.controller1?.reloadApi()
//        print(self.controller1?.Api)
//
//        self.controller1?.fetchdata(Api: self.controller1?.Api ?? "")
//        self.controller1?.test.reloadData()
//        //self.controller1?.viewDidLoad()
//        //self.controller1?.fetchdata(Api: self.controller1)
//        //self.controller1?.reloadInputViews()
//        //self.controller1?.fetchdata(Api: self.contapi)
//        //self.controller1?.Api = "?q=\(self.controller1?.search)&from=\(self.controller1?.from)&size=\(self.controller1?.size)"
//        //self.viewDidLoad()
//        //self.controller1?.fetchdata(Api: "?q=\(searchapi)")
//        //self.controller1?.tableView.reloadData()
//        self.pageMenu?.moveToPage(0)
//        print("finsh")
//
//        //setupPageMenu()
//    }
    func setupPageMenu() {
        
        //Create controllers
        //        let colors = [UIColor.black, UIColor.blue, UIColor.red, UIColor.gray, UIColor.green, UIColor.purple, UIColor.orange, UIColor.brown, UIColor.cyan]
        //        let controllers = colors.map { (color: UIColor) -> UIViewController in
        //            let controller = UIViewController()
        //            controller.view.backgroundColor = color
        //            return controller
        //        }
        //
        //var kind = ["search":UIViewController(),"youtube":UIViewController(),"17":UIViewController()]
        
        
        
        //let controller1 = storyboard?.instantiateViewController(withIdentifier: "TotalVC") as? TotalVC
        //controller1?.Api = ""
        //controller1?.view.backgroundColor = .red
//        controller1?.Methord = "q"
//        controller1?.Value = "youtube"
//        controller1?.title = "Search"
//
//        controllerArray.append(controller1 ?? controller0)
        
        
        //controller2?.Api = "?platform=youtube&from=\(controller2?.from)&size=\(controller2?.size)"
        //controller2?.platform = "youtube"
        controller2?.Methord = "platform"
        controller2?.Value = "Twitch"
        //controller2?.view.backgroundColor = .orange
        controller2?.title = "Twitch"
        controllerArray.append(controller2 ?? controller0)


   
        //controller3?.Api = "?platform=17"
        //controller3?.platform = "YouTube"
        controller3?.Methord = "platform"
        controller3?.Value = "YouTube"
        //controller3.view.backgroundColor = .green
        controller3?.title = "YouTube"
        controllerArray.append(controller3 ?? controller0)

        
        //controller4?.Api = "?platform=twitch"
        //controller4?.platform = "twitch"
        controller4?.Methord = "platform"
        controller4?.Value = "FaceBook"
        //controller4.view.backgroundColor = .blue
        controller4?.title = "FaceBook"
        controllerArray.append(controller4 ?? controller0)
        
        controller5?.Methord = "platform"
        controller5?.Value = "17"
        //controller4.view.backgroundColor = .blue
        controller5?.title = "17live"
        controllerArray.append(controller5 ?? controller0)
        
        controller6?.Methord = "platform"
        controller6?.Value = "西瓜直播"
        //controller4.view.backgroundColor = .blue
        controller6?.title = "西瓜直播"
        controllerArray.append(controller6 ?? controller0)
        
        controller7?.Methord = "platform"
        controller7?.Value = "西瓜直播"
        //controller4.view.backgroundColor = .blue
        controller7?.title = "西瓜直播"
        controllerArray.append(controller7 ?? controller0)
        
//
//        let controller5 = storyboard?.instantiateViewController(withIdentifier: "TotalVC") as? TotalVC
//        controller5?.Api = "?platform=西瓜"
//        //controller4.view.backgroundColor = .blue
//        controller5?.title = "Blue"
//        controllerArray.append(controller5 ?? controller0)
        //Create page menu
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .bottomMenuHairlineColor(UIColor.white),
            .selectionIndicatorColor(UIColor.white),
            .menuMargin(20.0),
            .menuHeight(40.0),
            .selectedMenuItemLabelColor(UIColor.green),
            .unselectedMenuItemLabelColor(UIColor.gray),
            .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(2.0),
            .menuItemSeparatorPercentageHeight(0.1),
            .centerMenuItems(true),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges (true),
            .menuItemWidthBasedOnTitleTextWidth (true)
            //.menuItemSeparatorWidth (100)
            
        ]
        //设置菜单位置
        let frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height)
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: frame, pageMenuOptions: parameters)
         //self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, in: self, with: dummyConfiguration(), usingStoryboards: true)
        //    self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, in: self, with: dummyConfiguration(), usingStoryboards: true)
        
    }
    
    func addActionButton() -> Void {
        let twitterImage = UIImage(named: "channel0.jpg")!
        let plusImage = UIImage(named: "channel1.jpg")!
        
        
        let google = ActionButtonItem(title: "密码设置", image: plusImage)
        google.action = { item in print("Google Plus...") }
        
        let twitter = ActionButtonItem(title: "退 出", image: twitterImage)
        twitter.action = { item in print("Twitter...") }
        
        actionButton = ActionButton(attachedToView: self.pageMenu?.view ?? self.view, items: [twitter, google])
        actionButton.action = { button in button.toggleMenu() }
        // 在这里设置按钮的相关属性，其实就是把刚刚那两个文件中的原始属性给覆盖了一遍，这里仅覆盖了2个旧属性
        actionButton.setTitle("=", forState: .normal)
        
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
    }
    
    func dummyConfiguration() -> CAPSPageMenuConfiguration {
        let configuration = CAPSPageMenuConfiguration()
        
        return configuration
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
