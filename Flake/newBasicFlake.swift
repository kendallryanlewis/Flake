//
//  newBasicFlake.swift
//  Flake
//
//  Created by Kendall Lewis on 7/4/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit

class newBasicFlake: UIViewController {
    @IBOutlet weak var basicFlakeTitle: UITextField!
    @IBOutlet weak var basicFlakeLocation: UITextField!
    @IBOutlet weak var basicFlakeDate: UITextField!
    @IBOutlet weak var basicFlakeDuration: UITextField!
    @IBOutlet weak var basicFlakePrice: UITextField!
    @IBOutlet weak var submitBasicButton: UIButton!
    @IBOutlet weak var basicFlakeDetails: UITextView!
    @IBOutlet weak var basicFlakePartyAmount: UITextField!
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
        let party = Int(basicFlakePartyAmount.text!)
        if title != "" || date != "" || location != "" || price != 0{
            flakeList.append(flakeDisplay(flakeID: ID, flakeTitle: title, flakeDetails: details, flakeDate: date, flakeLocation: location, flakePrice: price!, flakeParty: party!, amountPaid: 0, totalAmountPaid: 0))
                
            pageControlCount = pageControlCount + 1
            performSegue(withIdentifier: "mainSegueFromBasicFlake", sender: self)//segues to the main page
        }
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
