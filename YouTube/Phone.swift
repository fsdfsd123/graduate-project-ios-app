//
//  ViewController.swift
//  PhoneNumberAuthenticationWithFirebase
//
//  Created by Soeng Saravit on 12/17/18.
//  Copyright © 2018 Soeng Saravit. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class Phone: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Auth.auth().languageCode = "km";
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        let phoneNumber = phoneNumberTextField.text
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            // Sign in using the verificationID and the code sent to the user
            // ...
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            let alert = UIAlertController(title: "Verify code", message: "Please enter code sent to your phone number", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "123456"
            })
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID!,
                    verificationCode: alert.textFields![0].text!)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        // ...
                        print(error.localizedDescription)
                    }else{
                        // User is signed in
                        print("===> User is logged in")
                        ilivenetUser.name = phoneNumber ?? ""
                        ilivenetUser.email = phoneNumber ?? ""
                        ilivenetUser.history = [history(video: FsdVideo(), videourl: "", starttime: Date(), endtime: Date(), duration: 0)]
                        //ilivenetUser.photoURL = String(user?.photoURL) ??
                        
                        
                        //let photo:String = "\(user?.photoURL)"
                        let database: DatabaseReference = Database.database().reference()
                        database.child("users").child("\(phoneNumber)").child("email").setValue(phoneNumber)
                        database.child("users").child("\(phoneNumber)").child("displayName").setValue(phoneNumber)
                        database.child("users").child("\(phoneNumber)").child("photoURL").setValue(phoneNumber)
                        database.observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            let ipaddress = snapshot.value as? String
                            //                let value = snapshot.value as? NSDictionary
                            //                let username = value?["username"] as? String ?? ""
                            //                let user = User(username: username)
                            print("ipaddress:\(ipaddress)")
                            // ...
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                        print("ipaddress:\(ipaddress)")
                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "side") {
                            UIApplication.shared.keyWindow?.rootViewController = viewController
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    
                }
            })
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
           
        }
        
    }
}

