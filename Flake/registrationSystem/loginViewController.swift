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
        // Do any additional setup after loading the view.
        
        //Username and password and login button and facebook button
        userUsernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        userPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowRadius = 7
        signInButton.layer.shadowOpacity = 0.5
        signInButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        facebookButton.layer.cornerRadius = facebookButton.frame.height / 2
        facebookButton.layer.shadowColor = UIColor.black.cgColor
        facebookButton.layer.shadowRadius = 7
        facebookButton.layer.shadowOpacity = 0.5
        facebookButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Use Firebase library to configure Facebook APIs
        let loginButton = FBSDKLoginButton()
        facebookButton.addSubview(loginButton)
        loginButton.delegate = self as! FBSDKLoginButtonDelegate
        loginButton.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: 45) //40 left, 40 right contraint = (screen width - 80)
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        print("Did log out of facebook")
    }
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
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        /*let userUsername = userUsernameTextField.text
        let userPassword = userPasswordTextField.text
        
        let userUsernameStored = UserDefaults.standard.string(forKey: "userUsername")
        let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword")*/
        
        ref = Database.database().reference()
       /*********** Firebase *************/
        Auth.auth().signIn(withEmail: userUsernameTextField.text!, password: userPasswordTextField.text!) { (user, error) in
            if let error = error { print("Enter Valid email and password")
            }else{
                if Auth.auth().currentUser!.isEmailVerified == true{
                    guard let user = user?.user else { return }
                }
                UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
                UserDefaults.standard.synchronize()
                self.dismiss(animated: true, completion: nil)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    func textFieldShouldReturn(_ userPasswordTextField: UITextField) -> Bool {
        userPasswordTextField.resignFirstResponder()
        userUsernameTextField.resignFirstResponder()
        return true
    }
}

