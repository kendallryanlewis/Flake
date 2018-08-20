//
//  calculatorViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 8/20/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit

class calculatorViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var amountEntered: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        let addCurrentPayment = Int(amountEntered.text!)
        var flakeIndex = pageID - 1
        if flakeIndex <= 0 {
            flakeIndex = 0
        }else{
            
        }
        if addCurrentPayment != nil{
            print("Added payment \(addCurrentPayment)")
            flakeList[flakeIndex].amountPaid += addCurrentPayment!
            flakeList[flakeIndex].totalAmountPaid += addCurrentPayment!
            //myAmountPaid = flakeList[flakeIndex].amountPaid
            //ourAmountPaid = flakeList[flakeIndex].totalAmountPaid
            
            print("flake page Id \(pageID)")
            print("flake index \(flakeIndex)")
            print ("addCurrenPayment \(addCurrentPayment)")
            //print("my amount paid \(myAmountPaid)")
            //print("total amount paid \(ourAmountPaid)")
        }
        performSegue(withIdentifier: "calcToMainSegue", sender: self)//segues to the settings page
    }
}
