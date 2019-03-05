//
//  settingsViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 7/18/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseDatabase

class settingsViewController: UIViewController{
    @IBOutlet weak var backgroundNumber: UITextField!
    @IBOutlet weak var progressBarNumber: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backgrounThemeText: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundGlass: UIImageView!
    
    @IBOutlet weak var themeSwitch: UISwitch!
    var cell : UITableViewCell!
    
    var ref:DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /***************** firebase database ***************/
        ref = Database.database().reference()
        loadBackground()
        changeText()
        themeSwitch.addTarget(self, action: #selector(switchToggle(_:)), for: UIControlEvents.valueChanged)
    }
    func loadBackground(){
        backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background\(bg).png")!)
        backgroundGlass.backgroundColor = UIColor(patternImage: UIImage(named: "glass\(glass).png")!)
    }
    
    @IBAction func switchToggle(_ sender: UISwitch) {
        changeText()
    }

    func changeText() {
        if themeSwitch.isOn {
            backgrounThemeText.text = "Switch is on"
            backgroundGlass.backgroundColor = UIColor(patternImage: UIImage(named: "glassLight.png")!)
            glass = "Light"
        } else {
            backgrounThemeText.text = "Switch is off"
            backgroundGlass.backgroundColor = UIColor(patternImage: UIImage(named: "glassDark.png")!)
            glass = "Dark"
        }
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        if backgroundNumber.text != ""{
            bg = Int(backgroundNumber.text!)!
            let postBackground = [
                "background": "\(bg)", //post background
                ] as [String : Any]
            ref?.child("userAccounts/\(uid)").updateChildValues(postBackground) //post all account info into UserAccount database
        }
        if progressBarNumber.text != "" {
            pb = Int(progressBarNumber.text!)!
            let postProgressBar = [
                "progressBar": "\(pb)", //post progressBar
                ] as [String : Any]
            ref?.child("userAccounts/\(uid)").updateChildValues(postProgressBar) //post all account info into UserAccount database
        }
        performSegue(withIdentifier: "setttingsToMainSegue", sender: self)//segues to the feed page
    }
    
    //Hide keyboard when the users touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
