//
//  loadLaunchScreenViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 9/2/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit

class loadLaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.performSegue(withIdentifier: "loadToLaunchScreen", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if (!isUserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }
}
