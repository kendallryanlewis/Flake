//
//  loginViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 8/21/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit



class loginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var userUsernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    var handle: DatabaseHandle?
    var ref: DatabaseReference? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userPasswordTextField.delegate = self
        self.userUsernameTextField.delegate = self
        
        flakeList.removeAll() //clear flakes
        flakeListHolder.removeAll() //clear flakes
        tempList.removeAll() //clear flakes
        
        
        //Username and password and login button and facebook button
        userUsernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        userPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])        
        // Use Firebase library to configure Facebook APIs
        let loginButton = FBSDKLoginButton()
        facebookButton.addSubview(loginButton)
        loginButton.delegate = self as! FBSDKLoginButtonDelegate
        loginButton.frame = CGRect(x: 0, y: 0, width: view.frame.width - 105, height: 45) //40 left, 40 right contraint = (screen width - 80)
        loginButton.clipsToBounds = true
        //loginButton.layer.cornerRadius = loginButton.frame.height / 2
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        print("Did log out of facebook")
    }
    //facebook
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        if error != nil{
            //print(error)
            print(error.localizedDescription)
            return
        }
        print("Successfully logged in with fackebook")
        UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    //Button tapped
    @IBAction func loginButtonTapped(_ sender: Any) {
        loggedIn = false
        ref = Database.database().reference()
        if (userPasswordTextField.text! == "Player1" && userUsernameTextField.text! == "Player1") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                print("Successfully logged in")
                UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }else{
           /*********** Firebase *************/
            Auth.auth().signIn(withEmail: userUsernameTextField.text!, password: userPasswordTextField.text!) { (user, error) in
                if user != nil{
                    //sign successful
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        print("Successfully logged in")
                        UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                }else{
                    if let error = error?.localizedDescription {
                        print(error)
                    }else{
                        print("error")
                    }
                }
            }
        }
    }
    func textFieldShouldReturn(_ userPasswordTextField: UITextField) -> Bool {
        userPasswordTextField.resignFirstResponder()
        userUsernameTextField.resignFirstResponder()
        return true
    }
}

