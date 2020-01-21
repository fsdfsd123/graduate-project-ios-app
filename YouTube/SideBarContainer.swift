


import SidebarOverlay

class SideBarContainer: SOContainerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //講NavVC 和 expanedtableview 引入在 sidebarcontainer 中形成一個 有sidebar 的效果
        self.menuSide = .left
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavVC")
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpanedTableView")
        
    }
    
    
 
}
