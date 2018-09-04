//
//  newBasicFlake.swift
//  Flake
//
//  Created by Kendall Lewis on 7/4/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseDatabase
import FirebaseAuth

class newBasicFlake: UIViewController {
    @IBOutlet weak var basicFlakeTitle: UITextField!
    @IBOutlet weak var basicFlakeLocation: UITextField!
    @IBOutlet weak var basicFlakeDate: UITextField!
    @IBOutlet weak var basicFlakeDuration: UITextField!
    @IBOutlet weak var basicFlakePrice: UITextField!
    @IBOutlet weak var submitBasicButton: UIButton!
    @IBOutlet weak var basicFlakeDetails: UITextView!
    @IBOutlet weak var basicFlakePartyAmount: UITextField!
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func newBasicFlakeSubmitButton(_ sender: Any) {//click the new basic submit button
        let title = basicFlakeTitle.text!
        let details = basicFlakeDetails.text!
        let date = basicFlakeDate.text!
        let location = basicFlakeLocation.text!
        let price = Int(basicFlakePrice.text!)
        let ID = pageID + 1
        var flakeID = flakeIdentification
        let party = Int(basicFlakePartyAmount.text!)
        if title != "" || date != "" || location != "" || price != 0{
            flakeList.append(flakeDisplay(flakeID: ID, flakeTitle: title, flakeDetails: details, flakeDate: date, flakeLocation: location, flakePrice: price!, flakeParty: party!, amountPaid: 0, totalAmountPaid: 0))
                
            pageControlCount = pageControlCount + 1
            performSegue(withIdentifier: "mainSegueFromBasicFlake", sender: self)//segues to the main page
        }
        /************* Firebase database ****************/
        ref = Database.database().reference()
        
        print("This is ID \(flakeID)")
        let postFlake = [
            "flakeID": "\(ID)", //add username to database
            "flakeTitle": "\(title)",
            "flakeDetails": "\(details)", //add password to database
            "flakeDate": "\(date)", //add empty flakes to database
            "flakeLocation":  "\(location)", //add username to database
            "flakePrice": "\(basicFlakePrice.text!)", //add password to database
            "flakeParty": "\(basicFlakePartyAmount.text!)", //add empty flakes to database
            "amountPaid": "0",
            "totalAmountPaid":"0"
            ] as [String : Any]
        ref?.child("flakes/flake\(flakeIdentification)").setValue(postFlake) //post all account info into UserAccount database
   
        
        print(newFlakes + "," + String(flakeID))
        ref?.child("userAccounts/\(uid)/flakeIds").setValue(newFlakes + "," + String(flakeID))
        //Add to all other people in party
        flakeID += 1 //update date to new flake
        ref?.child("flakeIdentification/flakeIdentification").setValue(String(flakeID))
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
