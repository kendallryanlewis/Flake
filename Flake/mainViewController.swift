//
//  mainViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 6/19/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseDatabase
import MBCircularProgressBar
import ChameleonFramework

let indexPath = IndexPath(row: flakeList.count - 1, section: 0)

var menuList = [menuDisplay(menuItem: "MyAccount", menuDetails: Int(1)),
                menuDisplay(menuItem: "New Flake", menuDetails: Int(0)),
                menuDisplay(menuItem: "Help", menuDetails: Int(0)),
                menuDisplay(menuItem: "History", menuDetails: Int(3)),
                menuDisplay(menuItem: "Options", menuDetails: Int(0)),
                menuDisplay(menuItem: "Logout", menuDetails: Int(0))]

var flakeList = [flakeDisplay]()
var flakeListHolder = [flakeDisplay]()
var flakeAdder = [String]()
var tempList = [flakeDisplay]()

var currentFlakes = flakeList.count //count how many flakes the user has
var pageControlCount :Int = 0
var pageID = 0
var page = 0
var flakeIdentification = 0
var userFlakeID = 0
let notification = UINotificationFeedbackGenerator() //haptic feedback generator


/**************** Settings variables ****************/
var bg = 1 //system background
var glass:String = "Light" //system glass
var pb:Int = 1 //system progress Bar
/**************** Settings variables ****************/



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
    var flakeMembers = ""
    init(flakeID: Int, flakeTitle: String, flakeDetails: String, flakeDate: String, flakeLocation: String, flakePrice:Int, flakeParty:Int, amountPaid:Int, totalAmountPaid:Int, flakeMembers:String){
        self.flakeID = flakeID
        self.flakeTitle = flakeTitle
        self.flakeDetails = flakeDetails
        self.flakeDate = flakeDate
        self.flakeLocation = flakeLocation
        self.flakePrice = flakePrice
        self.flakeParty = flakeParty
        self.amountPaid = amountPaid
        self.totalAmountPaid = totalAmountPaid
        self.flakeMembers = flakeMembers
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
class mainViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, FBSDKLoginButtonDelegate{
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var featureScrollView: UIScrollView!
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var personalProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var ubeView: UIView! //mainView
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var featureScrollViewDetails: UIScrollView!
    @IBOutlet weak var featureScrollViewCalculator: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var usernameDisplay: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addNewFlakeFeature: UIView!
    @IBOutlet weak var addNewFlakeHighlight: UIImageView!
    @IBOutlet var gestureRecognizer: UISwipeGestureRecognizer!
    
    var contentWidth:CGFloat = 0.0
    var menuIsVisible = false//sets menu to close
    var detailsIsVisible = false//sets details to close
    var cell : UITableViewCell!
    var label = UILabel()
    var container = UIView()
    var flakeIdList = [flakeDisplay]()
    var maxPrice = 0 //Max price for trip
    var personalPrice = 0 //Personal price for trip
    var featureArray = flakeList 

    var featureHolderArray = flakeListHolder
    var tripPrice = 0
    var flakeParty = 0
    var myPrice = 0
    var myAmountPaid = 0
    var ourAmountPaid = 0
    var flakeIndex = 0
    var addPayment = 0
    var ref:DatabaseReference?
    var databaseHandle: DatabaseHandle?
    var reachability:Reachability?
    
    
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reachability = Reachability.init()!
        if ((self.reachability!.connection) != .none){ //if internet is found
            print("Internet Connection Found")
            loggedIn = true //set logged in to true
            loadBackground() //load background images
            getFacebookUserInfo() //Gather facebook info if needed
            /************** Paralax effect
            let min = CGFloat(-30)
            let max = CGFloat(30)
            let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
            xMotion.minimumRelativeValue = min
            xMotion.maximumRelativeValue = max
            let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
            yMotion.minimumRelativeValue = min
            yMotion.maximumRelativeValue = max
            let motionEffectGroup = UIMotionEffectGroup()
            motionEffectGroup.motionEffects = [xMotion,yMotion]
            backgroundImageView.addMotionEffect(motionEffectGroup) *************/
            /*********menu table view*********/
            let menuIndexPath = IndexPath(row: menuList.count - 1, section: 0)
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
            /**************** Pregress bars ******************/
            featureScrollViewDetails.isHidden = true//hide details
            featureScrollViewCalculator.isHidden = true//hide details
            backgroundImage.contentMode = UIViewContentMode.scaleAspectFit
            /**************** Firebase Database ******************/
            ref = Database.database().reference()
            firebaseFlakeIdentification() //Gather flake indentification
            /******************** Features *****************/
            pageControlCount = currentFlakes //add page dots
            featureScrollView.delegate = self
            featureScrollView.isPagingEnabled = true
            featureScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count + featureHolderArray.count + 1), height: 250)
            featureScrollViewDetails.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count + featureHolderArray.count), height: 250)
            featureScrollViewCalculator.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count + featureHolderArray.count), height: 250)
            featureScrollView.showsVerticalScrollIndicator = false
            featureScrollViewDetails.showsVerticalScrollIndicator = false
            featureScrollViewCalculator.showsVerticalScrollIndicator = false
            loadFeatures()//Gather and display user flakes
            addNewFlakeFeature.isHidden = true
            tempList.append(contentsOf: flakeList)
            tempList.append(contentsOf: flakeListHolder)
            /******************** Feature shadow *****************/
            featureScrollView.layer.shadowColor = UIColor.black.cgColor
            featureScrollView.layer.shadowOpacity = 1
            featureScrollView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
            featureScrollView.layer.shadowRadius = 10
            /******************** Background Image *****************/
            //let bounds = UIScreen.main.bounds
            //let width = bounds.size.width
            let screenSize: CGRect = UIScreen.main.bounds
            backgroundImage.frame = CGRect(x: 0, y: 0, width: screenSize.width * 2, height: screenSize.height)
            /***************** Progress Bar Loading ***************/
            progressBar.isHidden = true
            personalProgressBar.isHidden = true
            loadProgressBar()
        
            //mainView.backgroundColor = FlatGreenDark()
            
            let up = UISwipeGestureRecognizer(target : self, action : #selector(mainViewController.upSwipe))
            up.direction = .up
            self.featureScrollView.addGestureRecognizer(up)
            
            let down = UISwipeGestureRecognizer(target : self, action : #selector(mainViewController.downSwipe))
            down.direction = .down
            self.featureScrollView.addGestureRecognizer(down)
        }else{
            print("Internet Connection Not Found")
            performSegue(withIdentifier: "offlineSegue", sender: self)//segues to the offline page
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 10){
            //self.example.value = 70
        }
    }
    
    func loadBackground(){
        backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background\(bg).png")!)
        addNewFlakeHighlight.backgroundColor = UIColor(patternImage: UIImage(named: "glass\(glass).png")!)
    }
    
    func loadProgressBar(){
        switch pb {
            case 1:
                //print("Angled half circle")
                progressBar.progressAngle = 40
                progressBar.progressRotationAngle = -15
                personalProgressBar.progressAngle = 45
                personalProgressBar.progressRotationAngle = -15
            case 2:
                //print("Full Circle")
                progressBar.progressAngle = 100
                progressBar.progressRotationAngle = 0
                personalProgressBar.progressAngle = 100
                personalProgressBar.progressRotationAngle = 0
            case 3:
                //print("Full inner circle with Three/Quarter circle facing bottom right")
                progressBar.progressAngle = 70
                progressBar.progressRotationAngle = -10
                personalProgressBar.progressAngle = 100
                personalProgressBar.progressRotationAngle = 0
            case 4:
                //print("Three/Quarter circle facing bottom right")
                progressBar.progressAngle = 70
                progressBar.progressRotationAngle = -10
                personalProgressBar.progressAngle = 75
                personalProgressBar.progressRotationAngle = -10
            case 5:
                //print("Three/Quarter circle facing right")
                progressBar.progressAngle = 70
                progressBar.progressRotationAngle = -25
                personalProgressBar.progressAngle = 75
                personalProgressBar.progressRotationAngle = -25
            case 6:
                //print("Three/Quarter Circle facing down")
                progressBar.progressAngle = 70
                progressBar.progressRotationAngle = 0
                personalProgressBar.progressAngle = 75
                personalProgressBar.progressRotationAngle = 0
            
            default:
                progressBar.progressAngle = 70
                progressBar.progressRotationAngle = 0
                personalProgressBar.progressAngle = 75
                personalProgressBar.progressRotationAngle = 0
        }
    }
    
    func firebaseFlakeIdentification(){
        ref?.child("flakeIdentification/flakeIdentification").observe(.value, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post{
                flakeIdentification = Int(actualPost)!
            }
        })
    }
    
    
    /*func messageCell(){
        var items = ["Item 1", "Item2", "Item3", "Item4"]
        // MARK: - UITableViewDataSource
        override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
        
        override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            let identifier = "Cell"
            var cell: CustomOneCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomOneCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "CustomCellOne", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomOneCell
            }
            
            return cell
        }
    }*/
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        page = Int(scrollView.contentOffset.x / scrollView.frame.size.width) //set the page size
        let currentPage = page + 1 //Get the current page number for the ID
        pageID = Int(currentPage) //add to pageID
        featureScrollViewDetails.contentOffset = featureScrollView.contentOffset
        featureScrollViewCalculator.contentOffset = featureScrollView.contentOffset
        /********* Animate ui view *************/
        if (pageID > featureArray.count + featureHolderArray.count && pageID < featureArray.count + featureHolderArray.count + 2 ){
            print("This is the last empty spot")
            addNewFlakeFeature.isHidden = false
            
            
            addNewFlakeHighlight.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.2) {//slide animation
                self.addNewFlakeFeature.transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
            }
            UIView.animate(withDuration: 0.7) {//slide animation
                self.addNewFlakeFeature.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }
        }else{
            addNewFlakeFeature.isHidden = true
            self.addNewFlakeFeature.transform = CGAffineTransform.identity.scaledBy(x: 0.4, y: 0.4)
        }
    }
    
    @objc func moreButtonPressed(sender:UIButton){
        notification.notificationOccurred(.success) //haptic feedback
        
        progressBar.isHidden = false
        personalProgressBar.isHidden = false
        featureScrollView.isHidden = true //hided
        featureScrollViewDetails.isHidden = false //show
        featureScrollViewCalculator.isHidden = true//hide
        let page = pageID - 1
                progressBar.isHidden = false
                personalProgressBar.isHidden = false
        if page >= 0{
            let price = Float(flakeList[page].flakePrice) //convert the price of the trip in to the variable
            let personalParty = Float(flakeList[page].flakeParty) //find the amount of people in trip
            let personalCurrentPrice = Float(price / personalParty)//figure out individual price
            let personalPaid = Float(flakeList[page].amountPaid)
            let groupPaid = Float(flakeList[page].totalAmountPaid)
            let personalPercentage = Float(personalPaid / personalCurrentPrice)
            let groupPercentage = Float(groupPaid / price)
            if personalPercentage >= 1{
                UIView.animate(withDuration: 2){
                    self.progressBar.value = CGFloat(1)
                    self.personalProgressBar.value = CGFloat(1)
                    print("percentage \(1)")
                }
            }else{
                UIView.animate(withDuration: 2){
                    self.progressBar.value = CGFloat(groupPercentage)
                    self.personalProgressBar.value = CGFloat(personalPercentage)
                    //print("group percentage \(Float(personalPercentage))")
                    //print("personal percentage \(Float(personalPercentage))")
                }
            }
        }
    }
    @objc func addPaymentButtonPressed(sender:UIButton){
        ref?.child("flakePots/flake\(flakeList[pageID - 1].flakeID)/members/\(uid)/pricePaid").observe(.value, with: { (snapshot) in //gather user flake list from firebase
            let post = snapshot.value as? String
            if let actualPost = post{
                currentFlakePrice = Int(actualPost)!
                print("post \(actualPost)")
                print("post current flake \(currentFlakePrice)")
            }
        })
        performSegue(withIdentifier: "calculatorSegue", sender: self)//segues to the calc page
    }
    @objc func returnHomeButtonPressed(sender:UIButton){
        notification.notificationOccurred(.success) //haptic feedback
        featureScrollView.isHidden = false//show feature
        featureScrollViewDetails.isHidden = true//hide
        featureScrollViewCalculator.isHidden = true //hide
        let bounds = UIScreen.main.bounds
        //let height = bounds.size.height
        self.progressBar.value = 0
        self.personalProgressBar.value = 0
        progressBar.isHidden = true
        personalProgressBar.isHidden = true
    }
    @objc func settingsButtonPressed(sender:UIButton){
        //count the page index
        if pageID == 0{
            print(flakeList[0].flakeID)
            userFlakeID = flakeList[0].flakeID
        }else{
            print(flakeList[pageID - 1].flakeID)
            userFlakeID = flakeList[pageID - 1].flakeID
        }
        performSegue(withIdentifier: "segueToFlakeSettings", sender: self)//segues to the feed page
    }
    /************ Start of Menu Section ***********/
    @IBAction func menuButtonTapped(_ sender: Any) {
        notification.notificationOccurred(.success) //haptic feedback
        if !menuIsVisible{ //If menu is not visible, display menu (OPENED)
            leadingConstraints.constant = 325 //shift to 325
            trailingConstraints.constant = 325//sift to  -35
            menuIsVisible = true //set main menu to false
            menuView.isHidden = false
            print("menu Active")
            UIView.animate(withDuration: 0.5) {
                self.backgroundImageView.alpha = 0.3
                self.backgroundImageView.alpha = 0.2
                self.backgroundImageView.alpha = 0.1
                self.backgroundImageView.alpha = 0.05
            }
            UIView.animate(withDuration: 0.3) {//slide animation
                self.ubeView.frame.origin.x += 300
            }
            UIView.animate(withDuration: 0.55) {//slide animation
                self.menuView.frame.origin.x += 300
            }
            progressBar.isHidden = true
            personalProgressBar.isHidden = true
        }else{//if menu is visible move the menu back (OPENED)
            leadingConstraints.constant = 0 //reset main menu back to zero
            trailingConstraints.constant = 0 // reset main menu back to zero
            print("close menu")
            UIView.animate(withDuration: 1) {
                self.backgroundImageView.alpha = 0.05
                self.backgroundImageView.alpha = 0.1
                self.backgroundImageView.alpha = 0.2
                self.backgroundImageView.alpha = 0.3
            }
            UIView.animate(withDuration: 0.3) { //slide animation
                self.ubeView.frame.origin.x -= 300
            }
            UIView.animate(withDuration: 0.3) { //slide animation
                self.menuView.frame.origin.x -= 300
            }
            menuIsVisible = false //set main menu to false
            menuView.isHidden = true//hide menu
        }
    }
    /******* Add more feature button ********/
    @IBAction func addFeatureButton(_ sender: Any) {
        notification.notificationOccurred(.success) //haptic feedback
        performSegue(withIdentifier: "newFlake", sender: self)//segues to the feed page
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
                let loginManager = FBSDKLoginManager()
                loginManager.logOut() //logout of facebook
                uid = ""
                try! Auth.auth().signOut() //sign user out
                UserDefaults.standard.set(false, forKey:"isUserLoggedIn") //user is no longer logged in /change to true
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "returnLoginView", sender: self) //segue to the login screen
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("loginButtonDidLogOut")
        userImage.image = UIImage(named: "fb-art.jpg")
        label.text = "Not Logged In"
        uid = ""
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("didCompleteWith")
        getFacebookUserInfo()
    }
    
    func getFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil){
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let data = result as! [String : AnyObject]
                
                self.usernameDisplay.text = data["name"] as? String
                
                let FBid = data["id"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.userImage.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            })
            connection.start()
        }
    }
    
    //Hide keyboard when the users touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: featureScrollView)
        //let yFromCenter = card.center.y - view.center.y
        
        if point.y > 0 {
            card.center = self.view.center
        }else {
            card.center = CGPoint(x: view.center.x, y: view.center.y + point.y)
        }
        if point.y > 300 {
            card.center = self.view.center
            //card.center = CGPoint(x: view.center.x, y: view.center.y + point.y)
        }
        if sender.state == UIGestureRecognizerState.ended {
            if card.center.y < view.frame.height - 500 {
                //move card up
                UIView.animate(withDuration: 0.5, animations: {
                    card.center = CGPoint(x: card.center.x, y: card.center.y - 900)
                    if card.center.y > card.center.y - 200 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){ //Delay 5 secs then segue. Needed to load flakes
                            let refreshAlert = UIAlertController(title: "Delete Flake", message: "Are you sure you want to delete Flake", preferredStyle: UIAlertControllerStyle.alert)
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                print("Handle Ok logic here")
                            }))
                            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                                UIView.animate(withDuration: 0.2, animations: {
                                    print("Handle Cancel Logic here")
                                    card.center = self.view.center
                                })
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                        }
                    }
                })
                return
            } else{
                //move card down
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x, y: card.center.y)
                 card.center = self.view.center
                })
                return
            }
        }
    }
    
    //presses the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        //searchController.resignFirstResponder()//hides keyboard
        return(true)
    }
    @objc func leftSwipe(){
        print("Swipe left")
    }
    @objc func rightSwipe(){
        print("Swipe right")
    }
    @objc func upSwipe(){
        print("Swipe up")
    }
    @objc func downSwipe(){
        print("Swipe down")
    }
}






