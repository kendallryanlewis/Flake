//
//  newFlakeViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 6/19/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit

class newFlakeViewController: UIViewController{
    
    /*************** New Flake connectors *******************/
    @IBOutlet weak var joinFlake: UIView!
    @IBOutlet weak var basicFlake: UIView!
    @IBOutlet weak var adminFlake: UIView!
    @IBOutlet weak var soloFlake: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    /*************** Admin Flake connectors *******************/
    @IBOutlet weak var submitAdministratorButton: UIButton!
    /*************** Solo Flake connectors *******************/
    @IBOutlet weak var submitSoloButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBackground()
        // Dvarny additional setup after loading the view.
        //joinFlake.layer.shadowColor = UIColor.black.cgColor
        //joinFlake.layer.shadowOpacity = 1
        //joinFlake.layer.shadowOffset = CGSize(width: 3.0, height: 0.0)
        //joinFlake.layer.shadowRadius = 10
        
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        UIView.animate(withDuration: 1) {
            //self.basicFlake.frame.origin.y += height / 4
            //self.adminFlake.frame.origin.y += height / 3
            //self.soloFlake.frame.origin.y += height / 2
            //self.joinFlake.frame.origin.y += height
        }
        
        
    }
    func loadBackground(){
        print("bg \(bg)")
        backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background\(bg).png")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*************** New Flake selection page *******************/
    @IBAction func clickJoinFlake(_ sender: Any) {
        //performSegue(withIdentifier: "joinFlakeSegue", sender: self)//segues to the next the page
    }
    @IBAction func ClickFlakeOne(_ sender: Any) {//Click the basic button to add basic flake
       performSegue(withIdentifier: "basicFlakeSegue", sender: self)//segues to the next the page
    }
    @IBAction func ClickFlakeTwo(_ sender: Any) {//click the administrator button to admin flake
        performSegue(withIdentifier: "administratorFlakeSegue", sender: self)//segues to the next the page
    }
    @IBAction func ClickFlakeThree(_ sender: Any) {//Click the Solo button to add solo flake
        performSegue(withIdentifier: "soloFlakeSegue", sender: self)//segues to the next the page
    }

    /*************** Admin Flake section *******************/
    @IBAction func newAdministratorFlakeSubmitButton(_ sender: Any) {//click the new administrator submit button
        //flakeList.append(flakeDisplay(flakeTitle: "newFlake", flakeDetails: "Who the hell knows", flakeDate: "Someday", flakeLocation: "Mars"))//Add new flake was clicked
        performSegue(withIdentifier: "mainSegueFromAdminFlake", sender: self)//segues to the main page
    }
    
    /*************** Solo Flake section *******************/
    @IBAction func newSoloFlakeSubmitButton(_ sender: Any) {//click the new solo submit button
        //flakeList.append(flakeDisplay(flakeTitle: "newFlake", flakeDetails: "Who the hell knows", flakeDate: "Someday", flakeLocation: "Mars")) //Add new flake that was clicked
        performSegue(withIdentifier: "mainSegueFromSoloFlake", sender: self)//segues to the main page
    }
}
