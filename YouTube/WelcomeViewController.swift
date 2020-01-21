

import UIKit
//import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
//import SwiftGifOrigin
class WelcomeViewController: VideoSplashViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet var backgroundimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       do {
            let imageData = try Data(contentsOf: Bundle.main.url(forResource: "earth-birth", withExtension: "gif")!)
            self.backgroundimage.image = UIImage.gif(data: imageData)
        } catch {
            print(error)
        }
        if let path = Bundle.main.path(forResource: "test3", ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            videoFrame = view.frame
            fillMode = .resizeAspectFill
            alwaysRepeat = true
            sound = true
            startTime = 12.0
            duration = 4.0
            alpha = 0.7
            backgroundColor = UIColor.black
            contentURL = url
        }
        self.title = ""
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unwindtoWelcomeView(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
   
    //facebook loogin
    @IBAction func facebookLogin(sender: UIButton) {
        print("facebook")
        self.showSpinner(onView: self.view)
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                let database: DatabaseReference = Database.database().reference()
                         database.child("users").observeSingleEvent(of: .value, with: { (snapshot) in

                             if snapshot.hasChild(user?.uid ?? ""){
                                 
                                 print("exist user")
                                 database.child("users").child(user?.uid ?? "").observeSingleEvent(of: .value, with: { (snapshot) in
                                     print("snapshot value\(snapshot.value)")
                                     let dic = snapshot.value as? NSDictionary
                                     let data = try! JSONSerialization.data(withJSONObject: dic, options: [])
                                     ilivenetUser = try! JSONDecoder().decode(ilivenetuser.self, from: data)
                                     print("first statistics:\(ilivenetUser.statistics)")
                                     ilivenetUser.name = user?.displayName ?? ""
                                     ilivenetUser.photoURL = "\(user?.photoURL)"
                                     writeuserdata()
                                     print("current user \(ilivenetUser)")
                                   }) { (error) in
                                     print(error.localizedDescription)
                                 }
                             }else{
                                 //載入user data
                                 ilivenetUser.uid = user?.uid ?? ""
                                 
                                 print("uid\(user?.uid)")
                                 ilivenetUser.name = user?.displayName ?? ""
                                 ilivenetUser.email = user?.email ?? ""
                                 ilivenetUser.recommendlist = [0,0,0,0]
                                 ilivenetUser.history = [history(video: FsdVideo(), videourl: "", starttime: Date(), endtime: Date(), duration: -1)]//初始化history
                                 ilivenetUser.userSearch = [userSearch(keyword: "", time: 0)]
                                 ilivenetUser.statistics = statistics()
                                 print("first statistics:\(ilivenetUser.statistics)")
                                 //ilivenetUser.statistics = statistics(platform: statistics.platform(), category: statistics.category())
                                 ilivenetUser.photoURL = "\(user?.photoURL)"
                                 database.child("users").child(user?.uid ?? "").setValue(ilivenetUser.convertToDict())
                                 database.child("uid").child(user?.uid ?? "").setValue(ilivenetUser.convertToDict())
                                 print("new user")
                             }


                         })
                         database.observeSingleEvent(of: .value, with: { (snapshot) in
                             ipaddress = snapshot.value as? String ?? "http://120.126.16.88:17777/"
                             
                             print("init ipaddress:\(ipaddress)")
                             // ...
                         }) { (error) in
                             print(error.localizedDescription)
                         }
                         print("ipaddress:\(ipaddress)")
                         // Present the sidebarcontainer view
                         print("current user \(ilivenetUser)")
                         self.removeSpinner()
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "side") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }
    }
    
    //google login
    @IBAction func googleLogin(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
        self.showSpinner(onView: self.view)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - GIDSignInDelegate Methods
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else {
            
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        
        //auth sigin
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            let database: DatabaseReference = Database.database().reference()
            database.child("users").observeSingleEvent(of: .value, with: { (snapshot) in

                if snapshot.hasChild(user?.uid ?? ""){
                    
                    print("exist user")
                    database.child("users").child(user?.uid ?? "").observeSingleEvent(of: .value, with: { (snapshot) in
                        print("snapshot value\(snapshot.value)")
                        let dic = snapshot.value as? NSDictionary
                        let data = try! JSONSerialization.data(withJSONObject: dic, options: [])
                        ilivenetUser = try! JSONDecoder().decode(ilivenetuser.self, from: data)
                        print("first statistics:\(ilivenetUser.statistics)")
                        ilivenetUser.name = user?.displayName ?? ""
                        ilivenetUser.photoURL = "\(user?.photoURL)"
                        writeuserdata()
                        print("current user \(ilivenetUser)")
                      }) { (error) in
                        print(error.localizedDescription)
                    }
                }else{
                    //載入user data
                    ilivenetUser.uid = user?.uid ?? ""
                    
                    print("uid\(user?.uid)")
                    ilivenetUser.name = user?.displayName ?? ""
                    ilivenetUser.email = user?.email ?? ""
                    ilivenetUser.recommendlist = [0,0,0,0]
                    ilivenetUser.history = [history(video: FsdVideo(), videourl: "", starttime: Date(), endtime: Date(), duration: -1)]//初始化history
                    ilivenetUser.userSearch = [userSearch(keyword: "", time: 0)]
                    ilivenetUser.statistics = statistics()
                    print("first statistics:\(ilivenetUser.statistics)")
                    //ilivenetUser.statistics = statistics(platform: statistics.platform(), category: statistics.category())
                    ilivenetUser.photoURL = "\(user?.photoURL)"
                    database.child("users").child(user?.uid ?? "").setValue(ilivenetUser.convertToDict())
                    database.child("uid").child(user?.uid ?? "").setValue(ilivenetUser.convertToDict())
                    print("new user")
                }


            })
            database.observeSingleEvent(of: .value, with: { (snapshot) in
                ipaddress = snapshot.value as? String ?? "http://120.126.16.88:17777/"
                
                print("init ipaddress:\(ipaddress)")
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            print("ipaddress:\(ipaddress)")
            // Present the sidebarcontainer view
            print("current user \(ilivenetUser)")
            self.removeSpinner()
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "side") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    

   
   
}
