//
//  ViewController.swift
//  LUExpandableTableViewExample
//
//  Created by Laurentiu Ungur on 21/11/2016.
//  Copyright © 2016 Laurentiu Ungur. All rights reserved.
//

import UIKit
import LUExpandableTableView
import GoogleSignIn
import Firebase

final class ExpanedTableView: UIViewController {
    // MARK: - Properties
    
    private let expandableTableView = LUExpandableTableView()
    
    private let cellReuseIdentifier = "MyCell"
    private let sectionHeaderReuseIdentifier = "MySectionHeader"

    @IBOutlet var HeaderView: AccountHeaderCell!//加入一個AccountHeaderCell
    
    override func viewDidLoad() {
        self.view.backgroundColor = .black
        super.viewDidLoad()
        //self.waitPayTable.separatorStyle = UITableViewCellEditingStyleNone;
        self.expandableTableView.separatorStyle = .none
        self.introduceSwipeGestureRecognizer()
        view.addSubview(HeaderView)//加入headview
        expandableTableView.frame = CGRect(x: 0, y: 900, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(expandableTableView)
     
        expandableTableView.register(MyTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        expandableTableView.register(UINib(nibName: "MyExpandableTableViewSectionHeader", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: sectionHeaderReuseIdentifier)
        //註冊xib
        expandableTableView.expandableTableViewDataSource = self as! LUExpandableTableViewDataSource
        expandableTableView.expandableTableViewDelegate = self as! LUExpandableTableViewDelegate
        expandableTableView.sectionIndexBackgroundColor = .green
    }
    
    func introduceSwipeGestureRecognizer() -> Void {
        // 初始化
        let NwSwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeGestureClick))
        // 设置几个手指轻扫触发
        NwSwipeGestureRecognizer.numberOfTouchesRequired = 1
        /**
         设置轻扫的方向
         UISwipeGestureRecognizerDirection 方向
         left : 向左
         right :向右
         up : 向上
         down : 向下
         */
        NwSwipeGestureRecognizer.direction = .left
        // 添加手势
        self.view.addGestureRecognizer(NwSwipeGestureRecognizer)
    }
    @objc func swipeGestureClick() -> Void {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = false
        }
        
    }
    // TODO : tapGestureClick 的事件
    @objc func tapGestureClick() -> Void {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = false
        }
       
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        expandableTableView.frame = CGRect(x: 0, y: 150, width: view.frame.width, height: UIScreen.main.bounds.height)
         HeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        expandableTableView.frame.origin.y += 20
        
    }
    
    @IBOutlet var Languages: [UIButton]!

    @IBOutlet var first: UIButton!
    
    //單擊跳出language的下拉式選單
    @IBAction func ChooseLanguage(sender: AnyObject) {
        first.titleLabel?.textAlignment = .center
        first.titleLabel?.text = language
        
        for Languages in Languages{
            UIView.animate(withDuration: 0.3, animations: {
                Languages.isHidden = !Languages.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    //選擇指定的language
    @IBAction func PressLanguages(sender: AnyObject) {
        let result = sender.currentTitle ?? ""
        print(result)
        switch (result){
            case "Chinese":
                language = "zh"
            case "English":
                language = "en"
            case "Japanese":
                language = "ja"
            default:
                break;
        }
        //language = result ?? ""
        for Languages in Languages{
            UIView.animate(withDuration: 0.3, animations: {
                Languages.isHidden = !Languages.isHidden
                self.view.layoutIfNeeded()
            })
        }
        first.titleLabel?.textAlignment = .center
        first.titleLabel?.text = result
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = false
        }
//        NotificationCenter.default.post(name: NSNotification.Name("getPlatformIndex"), object: nil)
//         NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PlatformIndex":1])
        switch(tempvc){
        case "homepage":
            
            let notificationName = Notification.Name("PresentHomePage")
            NotificationCenter.default.post(name: notificationName, object: nil,userInfo: ["PresentHomePage":0])
        case "platform":
            let notificationName = Notification.Name("getPlatformIndex")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PlatformIndex":0])
        case "category":
            let notificationName = Notification.Name("TurntoPageView")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PlatformIndex":0])
        default:
            return
        }
        //選好后則直接重新載入homepage
    }
   
}



// MARK: - LUExpandableTableViewDataSource

extension ExpanedTableView: LUExpandableTableViewDataSource {
    func numberOfSections(in expandableTableView: LUExpandableTableView) -> Int {
        return 20
    }
    
    //定義每個section里有幾j行
    func expandableTableView(_ expandableTableView: LUExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 0
        }
        if(section == 3){
            return 6
        }
       
        if(section == 4){
            return 0
        }
        
        else{
            return 0
        }
        
    }
    
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? MyTableViewCell else {
            assertionFailure("Cell shouldn't be nil")
            return UITableViewCell()
        }
        //定義每行的標題
        switch indexPath.section{
            
//        case 0:
//            switch(indexPath.row){
//                case 0:
//                    cell.label.text = "Subscriptions"
//                case 1:
//                    cell.label.text = "Recommended"
//                case 2:
//                    cell.label.text = "Today"
//                case 3:
//                    cell.label.text = "Hot"
//                case 4:
//                    cell.label.text = "Most Viewed"
//               case 5:
//                    cell.label.text = "Within 72 hours"
//                default:
//                    cell.label.text = ""
//                }
        case 3:
           
            switch(indexPath.row){
            case 0:
                cell.label.text = "Twitch"
            case 1:
                cell.label.text = "YouTube"
           
            case 2:
                cell.label.text = "liveme"
            case 3:
                cell.label.text = "17 Live"
            case 4:
                cell.label.text = "西瓜直播"
            case 5:
                cell.label.text = "kingkong"
            default:
                cell.label.text = ""
            }
            
        //case 4:
            /*var Bigcategory = ["GAME",
                       "Internet Celebrities",
                       "Talk Show",
                       "News",
                       "Auction",
                       "FM Radio",
                       "Sports",
                       "Music",
                       "Technology",
                       "animal"]
            cell.label.text = Bigcategory[indexPath.row]*/
            
        default:
            cell.label.text = ""
        }
        
        return cell
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, sectionHeaderOfSection section: Int) -> LUExpandableTableViewSectionHeader {
        guard let sectionHeader = expandableTableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderReuseIdentifier) as? MyExpandableTableViewSectionHeader else {
            assertionFailure("Section header shouldn't be nil")
            return LUExpandableTableViewSectionHeader()
        }
        sectionHeader.label.tintColor = .orange
        sectionHeader.backgroundColor = .gray
        switch section{
            //定義header的text
            case 0:
                sectionHeader.label.text = "HomePage"
                //sectionHeader.frame = CGRect(x: 0, y: 0, width: UIScreen.main., height: <#T##CGFloat#>)
            
            
            case 1:
                sectionHeader.label.text = "My follow"
            case 2:
                sectionHeader.label.text = "My history"
            case 3:
                sectionHeader.label.text = "Platform"
            case 4:
                sectionHeader.label.text = "Category"
            case 5:
                sectionHeader.label.text = "Sign Out"
            default:
                sectionHeader.label.text = ""
        }
        
        return sectionHeader
    }
    
   
}

// MARK: - LUExpandableTableViewDelegate

extension ExpanedTableView: LUExpandableTableViewDelegate {
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
        return 50
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        /// Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
        return 69
    }
    
    // MARK: - Optional
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = false
        }
        //MARK:turntoplatform
        if(indexPath.section == 3){
            
            //self.showSpinner(onView: self.view)
        //選到platform后，單擊哪個platform，就向navc發送notifi，傳入platfrom的index，再重新載入platform 的pageview，并跳到指定的platform的頁面
            let notificationName = Notification.Name("getPlatformIndex")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PlatformIndex":indexPath.row])
        
        }
        

        print("Did select cell at section \(indexPath.section) row \(indexPath.row)")
    }
    
    //單擊section的動作
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectSectionHeader sectionHeader: LUExpandableTableViewSectionHeader, atSection section: Int) {
        
        // MARK:turntohomepage
        if (section == 0){
            let notificationName = Notification.Name("PresentHomePage")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PresentHomePage":0])
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }

        }
        // MARK: turnto myfllow
        if(section == 1){
            let notificationName = Notification.Name("PresentHistory")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PresentHistory":"follow"])
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
        }
        // MARK: turnto history
        if (section == 2){
            let notificationName = Notification.Name("PresentHistory")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PresentHistory":"history"])
   
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
        }
        // MARK: turnto category
        if(section == 4){
              /*var Bigcategory = ["GAME",
                                    "Internet Celebrities",
                                    "Talk Show",
                                    "News",
                                    "Auction",
                                    "FM Radio",
                                    "Sports",
                                    "Music",
                                    "Technology",
                                    "animal"]
           let notificationName = Notification.Name("TurntoPageView")
           NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["TurntoPageView":Bigcategory[indexPath.row]])*/
            let notificationName = Notification.Name("TurntoPageView")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["TurntoPageView":"Category"])
            if let container = self.so_containerViewController {
                           container.isSideViewControllerPresented = false
            }
               
        }
        
     
        // MARK: signout
        if(section == 5){
            do {
                if let providerData = Auth.auth().currentUser?.providerData {
                    let userInfo = providerData[0]
                    
                    switch userInfo.providerID {
                    case "google.com":
                        GIDSignIn.sharedInstance().signOut()
                        
                    default:
                        break
                    }
                }
                
                try Auth.auth().signOut()
                
            } catch {
                let alertController = UIAlertController(title: "Logout Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                
                return
            }
            
            // Present the welcome view
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
        print("Did select section header at section \(section)")
   
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Will display cell at section \(indexPath.section) row \(indexPath.row)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplaySectionHeader sectionHeader: LUExpandableTableViewSectionHeader, forSection section: Int) {
        print("Will display section header for section \(section)")
    }

    func expandableTableView(_ expandableTableView: LUExpandableTableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func expandableTableView(_ expandableTableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
