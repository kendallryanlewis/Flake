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

var userUID:String  = ""

class registerPageViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var confirmUserPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var mainView: UIView!
    
    var ref: DatabaseReference?
    //var uid = ""
    var userAccountLocation:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        mainView.layer.shadowRadius = 10
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        let userUsername = usernameTextField.text
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userConfirmPassword = confirmUserPasswordTextField.text
        
        
        
        if userPassword != userConfirmPassword {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: userEmail!, password: userPassword!){ (user, error) in if error == nil {
                    let myAlert = UIAlertController(title:"Alert", message: "Registrations is successful. thank you!", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default){
                        action in
                        self.dismiss(animated: true, completion: nil)
                    }
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated:true, completion:nil)
                self.registerUser()
                }
                else{
                    //Display alert message
                    self.displayMyAlertMessage(userMessage: "All fields are required")
                    let myAlert = UIAlertController(title:"Alert", message: "All fields are required", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil)
                    myAlert.addAction(okAction)
                    return
                }
            }
        }
    }
    
    func registerUser(){
        /**************Firebase*****************/
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        userAccountLocation = "userAccounts/\(uid)/"
        let postUser = [
            "username": "\(usernameTextField.text!)", //add username to database
            "password": "\(userPasswordTextField.text!)", //add password to database
            "userID": "\(uid)", //add user ID to database
            "background": "1", //Backround to database
            "progressBar": "1", //Progress bar
            "flakeIds": "0" //add empty flakes to database
        ]
        ref?.child(userAccountLocation).setValue(postUser) //post all account info into UserAccount database
        let addUserID = [
            "userID": "\(uid)"
        ]
        ref?.child("currentUsers/\(usernameTextField.text!)").setValue(addUserID) //post all account info into UserAccount database
    }
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
    }
    //Hide keyboard when the users touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(usernameTextField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        confirmUserPasswordTextField.resignFirstResponder()
        userEmailTextField.resignFirstResponder()
        return true;
    }
}
