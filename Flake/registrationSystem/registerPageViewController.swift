//
//  registerPageViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 8/21/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase


class registerPageViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var confirmUserPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    
    var ref: DatabaseReference?
    let userID = Auth.auth().currentUser
    var uid = ""
    var userAccountLocation:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        let userUsername = usernameTextField.text
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userConfirmPassword = confirmUserPasswordTextField.text
        //check for empty fields
        if (userUsername == "" || userPassword == "" || userConfirmPassword == "" || userEmail == ""){
                //Display alert message
            displayMyAlertMessage(userMessage: "All fields are required")
            return
        }
        //Check if passwords match
        if (userPassword != userConfirmPassword){
            //Display an alert message
            displayMyAlertMessage(userMessage: "Passwords do not match")
            return
        }
        //Store data
        UserDefaults.standard.set(userUsername, forKey:"userUsername")
        UserDefaults.standard.set(userPassword, forKey:"userEmail")
        UserDefaults.standard.set(userPassword, forKey:"userPassword")
        UserDefaults.standard.synchronize();
        //display alert message with confirmation
        var myAlert = UIAlertController(title:"Alert", message: "Registrations is successful. thank you!", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default){
            action in
            self.dismiss(animated: true, completion: nil)
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil)
        
        /**************Firebase*****************/
        if (userID != nil) {
            uid = (userID?.uid)!
            print(uid as Any)
        }
        Auth.auth().createUser(withEmail: userEmail!, password: userPassword!) { (user, error) in //login username and password
            if let error = error {
                print(error.localizedDescription)
            }
            else if let user = user {
                print("Sign Up Successfully.")
            }
        }
        ref = Database.database().reference()
        userAccountLocation = "userAccounts/\(uid)"
        if userUsername != ""{ //If username is NOT empty
            let postUser = [
                "username": "\(usernameTextField.text!)", //add username to database
                "password": "\(userEmailTextField.text!)", //add password to database
                "flakeIds": "0" //add empty flakes to database
            ]
            ref?.child(userAccountLocation).setValue(postUser) //post all account info into UserAccount database
        }
        
    }
    func displayMyAlertMessage(userMessage:String){
        var myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
    }
    
    func textFieldShouldReturn(_ usernameTextField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        confirmUserPasswordTextField.resignFirstResponder()
        userEmailTextField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}
