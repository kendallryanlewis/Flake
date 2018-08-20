//
//  mainViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 6/19/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit
import UICircularProgressRing

let indexPath = IndexPath(row: flakeList.count - 1, section: 0)

var menuList = [menuDisplay(menuItem: "MyAccount", menuDetails: Int(1)),
                menuDisplay(menuItem: "New Flake", menuDetails: Int(0)),
                menuDisplay(menuItem: "Help", menuDetails: Int(0)),
                menuDisplay(menuItem: "History", menuDetails: Int(3)),
                menuDisplay(menuItem: "Options", menuDetails: Int(0)),
                menuDisplay(menuItem: "Logout", menuDetails: Int(9))]

var flakeList = [flakeDisplay(flakeID: 1, flakeTitle: "FlakeOne", flakeDetails: "Gathering for Winter trip!", flakeDate: "06/22/91", flakeLocation: "Denver,Co", flakePrice: 192, flakeParty: 12, amountPaid: 5, totalAmountPaid: 0), flakeDisplay(flakeID: 2, flakeTitle: "FlakeTwo", flakeDetails: "Summer trip!", flakeDate: "02/12/18", flakeLocation: "Waynesville", flakePrice: 3000, flakeParty: 3, amountPaid: 200, totalAmountPaid: 0), flakeDisplay(flakeID: 3, flakeTitle: "FlakeThree", flakeDetails: "Getting away for the weekend!", flakeDate: "tommorow", flakeLocation: "IDK!", flakePrice: 1200, flakeParty: 9, amountPaid: 90, totalAmountPaid: 0)]

var currentFlakes = flakeList.count //count how many flakes the user has
var pageControlCount :Int = 3
var pageID = 0
var page = 0
var bg = 0

class menuDisplay {
    var menuItem = ""
    var menuDetails = 0
    init(menuItem: String, menuDetails:Int) {
        self.menuItem = menuItem
        self.menuDetails = menuDetails
    }
}
class flakeDisplay{
    var flakeID = 0
    var flakeTitle = ""
    var flakeDetails = ""
    var flakeDate = ""
    var flakeLocation = ""
    var flakePrice = 0
    var flakeParty = 0
    var amountPaid = 0
    var totalAmountPaid = 0
    init(flakeID: Int, flakeTitle: String, flakeDetails: String, flakeDate: String, flakeLocation: String, flakePrice:Int, flakeParty:Int, amountPaid:Int, totalAmountPaid:Int){
        self.flakeID = flakeID
        self.flakeTitle = flakeTitle
        self.flakeDetails = flakeDetails
        self.flakeDate = flakeDate
        self.flakeLocation = flakeLocation
        self.flakePrice = flakePrice
        self.flakeParty = flakeParty
        self.amountPaid = amountPaid
        self.totalAmountPaid = totalAmountPaid
    }
}

class menuCell: UITableViewCell{ //Edit the menu cells
    @IBOutlet weak var menuItem: UILabel!
    @IBOutlet weak var menuDetails: UILabel!

    @IBInspectable var selectionColor: UIColor = .black {//adds selection color feature
        didSet {
            configureSelectedBackgroundView()
        }
    }
    func configureSelectedBackgroundView() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
        view.layer.masksToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.23
        view.layer.shadowRadius = 4
    }
}
class mainViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var featureScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var ubeView: UIView! //mainView
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var featureScrollViewDetails: UIScrollView!
    @IBOutlet weak var featureScrollViewCalculator: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var contentWidth:CGFloat = 0.0
    var menuIsVisible = false//sets menu to close
    var detailsIsVisible = false//sets details to close
    var cell : UITableViewCell!
    var label = UILabel()
    var container = UIView()
    var flakeIdList = [flakeDisplay]()
    var maxPrice = 0 //Max price for trip
    var personalPrice = 0 //Personal price for trip
    var featureArray = flakeList//[Dictionary<String,String>]()
    let flakeArray = flakeList
    var tripPrice = 0
    var flakeParty = 0
    var myPrice = 0
    var myAmountPaid = 0
    var ourAmountPaid = 0
    var flakeIndex = 0
    var addPayment = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /************** Paralax effect *************/
        /*let min = CGFloat(-100)
        let max = CGFloat(100)
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        backgroundImageView.addMotionEffect(motionEffectGroup)
        */
        let menuIndexPath = IndexPath(row: menuList.count - 1, section: 0)
        /*********menu table view*********/
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        menuTableView.beginUpdates()
        menuTableView.insertRows(at: [menuIndexPath], with: .automatic) //insert rows at tableview
        menuTableView.endUpdates()
        menuTableView.tableFooterView = UIView(frame: .zero) //remove empty rows in tableView
        menuView.isHidden = true//hide menu
       /*************** Transparent navbar **************/ self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        /******************** Features *****************/
        featureScrollView.delegate = self
        featureScrollView.isPagingEnabled = true
        featureScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count), height: 250)
        featureScrollViewDetails.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count), height: 250)
        featureScrollViewCalculator.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count), height: 250)
        featureScrollView.showsVerticalScrollIndicator = false
        featureScrollViewDetails.showsVerticalScrollIndicator = false
        featureScrollViewCalculator.showsVerticalScrollIndicator = false
        loadFeatures()
        
        /**************** Pregress bars ******************/
        pageControl.numberOfPages = pageControlCount
        
        featureScrollViewDetails.isHidden = true//hide details
        featureScrollViewCalculator.isHidden = true//hide details
        
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFit
        loadBackground()
    }
  
    func loadBackground(){
        print("bg \(bg)")
        if bg == 1 {
            backgroundImage.backgroundColor =
                UIColor(patternImage: UIImage(named: "background1.png")!)
        }else if bg == 2{
            backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background2.png")!)
        }else if bg == 3{
            backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "back ground3.png")!)
        }else if bg == 4{
            backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background4.png")!)
        }else if bg == 5{
            backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background5.png")!)
        }else if bg == 6{
            backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background6.png")!)
        }else if bg == 7{
            backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background7.png")!)
        }else if bg == 8{
            backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background8.png")!)
        }else if bg == 9{
            backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background9.png")!)
        }else if bg == 10{
            backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background10.png")!)
        }
    }

    
    func loadFeatures(){
        for (index, feature) in featureArray.enumerated(){ //iterate throughout the array for each flake
            if let featureView = Bundle.main.loadNibNamed("Feature", owner: self, options: nil)?.first as? FeatureView {
                featureView.flakeTitle.text = flakeList[index].flakeTitle//Flake title
                featureView.flakeLocation.text = flakeList[index].flakeLocation //Location of flake
                featureView.flakeDate.text = flakeList[index].flakeDate//Location of flakedateton
                featureView.flakeBalance.text = String(flakeList[index].totalAmountPaid)
                featureView.moreButton.addTarget(self, action: #selector(mainViewController.moreButtonPressed(sender:)), for: .touchUpInside)
                featureScrollView.addSubview(featureView) //Add this to enable Feature to display in scrollview
                featureView.frame.size.width = self.view.bounds.size.width
                featureView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
            }
            if let featureDetailsView = Bundle.main.loadNibNamed("FeatureDetails", owner: self, options: nil)?.first as? FeatureView {
                featureDetailsView.flakeDetailsTitle.text = flakeList[index].flakeTitle//Flake title
                featureDetailsView.flakeDetails.text = flakeList[index].flakeDetails //flake detials
                featureDetailsView.flakeDetailsDate.text = flakeList[index].flakeDate //set flake date
                featureDetailsView.flakeDetailsLocation.text = flakeList[index].flakeLocation //Location of flake
                featureDetailsView.addPaymentButton.tag = index //activate the moreButton
                featureDetailsView.addPaymentButton.addTarget(self, action: #selector(mainViewController.addPaymentButtonPressed(sender:)), for: .touchUpInside)
                featureDetailsView.returnHome.tag = index //activate the moreButton
                featureDetailsView.returnHome.addTarget(self, action: #selector(mainViewController.returnHomeButtonPressed(sender:)), for: .touchUpInside)
                featureScrollViewDetails.addSubview(featureDetailsView) //Add this to enable Feature to display in scrollview
                featureDetailsView.frame.size.width = self.view.bounds.size.width
                featureDetailsView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width

                tripPrice = flakeList[index].flakePrice
                flakeParty = flakeList[index].flakeParty
                myPrice = tripPrice / flakeParty
                myAmountPaid = flakeList[index].amountPaid
                ourAmountPaid = flakeList[index].totalAmountPaid
                
                featureDetailsView.progressBar.maxValue = UICircularProgressRing.ProgressValue(tripPrice)
                featureDetailsView.progressBar.startProgress(to: UICircularProgressRing.ProgressValue(ourAmountPaid), duration: 1.0)
                
                featureDetailsView.personalProgressBar.maxValue = UICircularProgressRing.ProgressValue(myPrice)
                featureDetailsView.personalProgressBar.startProgress(to: UICircularProgressRing.ProgressValue(myAmountPaid), duration: 1.0)
                
                print("trip price \(tripPrice)")
                print("personal price \(myPrice)")
                print("total amount paid \(ourAmountPaid)")
                print("my amount Paid \(myAmountPaid)")
            }
            if let addFeatureView = Bundle.main.loadNibNamed("addFeature", owner: self, options: nil)?.first as? FeatureView {
                //featureAddView.addButton.tag = index //activate the moreButton
                //featureAddView.addButton.addTarget(self, action: #selector(mainViewController.submitButtonPressed(sender:)), for: .touchUpInside)
                //featureScrollView.addSubview(featureAddView) //Add this to enable Feature to display in scrollview
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        page = Int(scrollView.contentOffset.x / scrollView.frame.size.width) //set the page size
        pageControl.currentPage = Int(page) //set the page dot
        let currentPage = page + 1 //Get the current page number for the ID
        pageID = Int(currentPage) //add to pageID
        
        featureScrollViewDetails.contentOffset = featureScrollView.contentOffset
        featureScrollViewCalculator.contentOffset = featureScrollView.contentOffset
        
        /*for (index, feature) in featureArray.enumerated(){//
            if currentPage == CGFloat(flakeList[index].flakeID){//If page is the same as ID
                maxPrice = flakeList[index].flakePrice
                personalPrice = maxPrice / flakeList[index].flakeParty
            }
        }
        if let featureView = Bundle.main.loadNibNamed("Feature", owner: self, options: nil)?.first as? FeatureView {
            featureView.progressBar.startProgress(to: 0, duration: 0.5) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { //Delay function
                    featureView.progressBar.startProgress(to:  UICircularProgressRing.ProgressValue(self.totalAmountPaid), duration: 1.0)
                })
            }
            featureView.personalProgressBar.startProgress(to: 0, duration: 0.5) { //Delay function
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    featureView.personalProgressBar.startProgress(to:  UICircularProgressRing.ProgressValue(self.myAmountPaid), duration: 1.0)
                })
            }
        }*/
    }
    
    @objc func moreButtonPressed(sender:UIButton){
        featureScrollView.isHidden = true //hidedrinks details
        featureScrollViewDetails.isHidden = false //show drinks details
        featureScrollViewCalculator.isHidden = true//hide drinks details
    }
    @objc func addPaymentButtonPressed(sender:UIButton){
        //featureScrollView.isHidden = true//hide
        //featureScrollViewDetails.isHidden = true
        //featureScrollViewCalculator.isHidden = false//hide drinks details
        performSegue(withIdentifier: "calculatorSegue", sender: self)//segues to the calc page
    }
    @objc func returnHomeButtonPressed(sender:UIButton){
        featureScrollView.isHidden = false
        featureScrollViewDetails.isHidden = true//hide drinks details
        featureScrollViewCalculator.isHidden = true //show drinks details
    }
    /************ Start of Menu Section ***********/
    @IBAction func menuButtonTapped(_ sender: Any) {
        if !menuIsVisible{ //If menu is not visible, display menu
            leadingConstraints.constant = 325 //shift to 325
            trailingConstraints.constant = 325//sift to  -35
            menuIsVisible = true //set main menu to false
            menuView.isHidden = false //show drinks menu
            print("menu Active")
        }else{//if menu is visible move the menu back
            leadingConstraints.constant = 0 //reset main menu back to zero
            trailingConstraints.constant = 0 // reset main menu back to zero
            menuIsVisible = false //set main menu to false
            menuView.isHidden = true//hide menu
            print("close menu")
        }
    }
    /******* Table View ********/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int?
        // code to check for a particular tableView.
        if tableView == self.menuTableView //access the menu table view
        {
            count = menuList.count
        }
        return count!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == self.menuTableView{ //access the menu table view
            var cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! menuCell?
            if cell == nil {
                tableView.register(menuCell.classForCoder(), forCellReuseIdentifier: "menuCell")
                cell = menuCell(style: UITableViewCellStyle.default, reuseIdentifier: "menuCell")
            }
            if let label = cell?.menuItem{ //populate cell with menu item name
                label.text = menuList[indexPath.row].menuItem
            }
            else{
                cell?.textLabel?.text = menuList[indexPath.row].menuItem
            }
            if let label = cell?.menuDetails{ //populate cell with menu details
                if menuList[indexPath.row].menuDetails == 0{ //if menu detail is 0 do not display
                    label.text = ""
                }else{
                    label.text = String(menuList[indexPath.row].menuDetails)
                }
            }
            else{
                if menuList[indexPath.row].menuDetails == 0{ ////if menu detail is 0 do not display
                    cell?.textLabel?.text = ""
                }else{
                    cell?.textLabel?.text = String(menuList[indexPath.row].menuDetails)
                }
            }
            return cell!
        }
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {//disables swipe to delete function for specific cells
        if tableView == menuTableView { //access the menu table view
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    
    /*************** Cell that was selected **************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//cells that were selected drink/menu
        if tableView == menuTableView{ //Select the menu list
            if menuList[indexPath.row].menuItem == "MyAccount"{
                print("My Account")
                //performSegue(withIdentifier: "settings", sender: self)//segues to the settings page
            } else if menuList[indexPath.row].menuItem == "New Flake"{
                print("Create New Flake")
                performSegue(withIdentifier: "newFlake", sender: self)//segues to the feed page
            }else if menuList[indexPath.row].menuItem == "Help"{
                print("Help")
                //performSegue(withIdentifier: "Help", sender: self)//segues to the feed page
            }else if menuList[indexPath.row].menuItem == "History"{
                print("History")
                //performSegue(withIdentifier: "History", sender: self)//segues to the history page
            }else if menuList[indexPath.row].menuItem == "Options"{
                print("Settings")
                performSegue(withIdentifier: "settingsSegue", sender: self)//segues to the settings page
            }else if menuList[indexPath.row].menuItem == "Logout"{
                print("Logout")
                /*********************************/
                /*******Add logout feature********/
                /*********************************/
            }
        }
    }
    
    //Hide keyboard when the users touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    //presses the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        //searchController.resignFirstResponder()//hides keyboard
        return(true)
    }
}
