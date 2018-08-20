//
//  settingsViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 7/18/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit



class settingsViewController: UIViewController {
    @IBOutlet weak var backgroundNumber: UITextField!
    
    @IBOutlet weak var backgroundButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func backgroundPressed(_ sender: Any) {
        bg = Int(backgroundNumber.text!)!
        performSegue(withIdentifier: "setttingsToMainSegue", sender: self)//segues to the feed page
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
