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
import MapKit



class userCell: UITableViewCell{
    @IBOutlet weak var userName: UILabel!
}

class usersFlake {
    var flakeIds = ""
    var flakeUserAccount = ""
    init(flakeIds: String, flakeUserAccount: String) {
        self.flakeIds = flakeIds
        self.flakeUserAccount = flakeUserAccount
    }
}

var flakeTitle:String = ""
var flakeDetails:String = ""
var flakeDate:String = ""
var flakeLocation:String = ""
var flakeDuration:String = ""
var flakePrice:Int = 0
var ID = pageID + 1
var flakeID:Int = 0
var flakeParty:Int = 0
var current = flakeList.count-1
var flakePartyAmount:String = ""
var flakeHolder = ""
var flakeUsers = [String]()
var flakeIdsList = [usersFlake]()
var flakeIds:String = ""
var flakeUserAccounts:String = ""

class newBasicFlake: UIViewController, UITextFieldDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var basicFlakeTitle: UITextField!
    @IBOutlet weak var basicFlakeLocation: UITextField!
    @IBOutlet weak var basicFlakeDate: UITextField!
    @IBOutlet weak var basicFlakeDuration: UITextField!
    @IBOutlet weak var basicFlakePrice: UITextField!
    @IBOutlet weak var basicFlakeDetails: UITextView!
    @IBOutlet weak var basicFlakePartyAmount: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var ref:DatabaseReference?
    var databaseHandle: DatabaseHandle?
    var currentIndex = 1
    var newName:String = "flake1"
    var firebaseDataIndex: String  = ""
    var postID = 0
    var postIndex = 0
    var newPost = 0
    var chrInteger:Int = 0
    var firebaseData1:Int = 0, firebaseData2:String = "", firebaseData3:String = "", firebaseData4:Int = 0, firebaseData5:String = "", firebaseData6:Int = 0, firebaseData7:Int = 0, firebaseData8:String = "", firebaseData9:Int = 0
    var Identification:String = ""
    var addUsers = ""
    var userFlakes:String = ""
    var flakeString:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBackground()
        /***************** user table view *****************/
        if tableView != nil{
            self.tableView.allowsMultipleSelection = true
            self.tableView.allowsMultipleSelectionDuringEditing = true
            self.tableView.delegate = self
            self.tableView.dataSource = self
            definesPresentationContext = true
            tableView.backgroundColor = UIColor.clear
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
        /***************** firebase database ***************/
        ref = Database.database().reference()
    }
    func loadBackground(){
        //print("bg \(bg)")
        backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "background\(bg).png")!)
    }
    @IBAction func continueToUsersButton(_ sender: Any) {
        if basicFlakeDate.text != "" || basicFlakeDuration.text != "" || basicFlakePrice.text != "" {
            flakeDate = basicFlakeDate.text!
            flakeDuration = basicFlakeDuration.text!
            flakePrice = Int(basicFlakePrice.text!)!
        }
    }
    @IBAction func continueToSubmitButton(_ sender: Any) {
        if let list = tableView.indexPathsForSelectedRows as [NSIndexPath]? {
            flakeParty = Int(list.count) + 1
            //print(list.count)
        }
    }
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        //Activy Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        //Hide search Bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        //Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        flakeLocation = searchBar.text!
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil{
                print("Error")
            }else{
                //remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //getting Data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //create annotations
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                //Zoming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)
            }
        }
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        print ("flakeLocation \(flakeLocation)")
        print ("flakeDate \(flakeDate)")
        print ("flakeDuration \(flakeDuration)")
        print ("flakePrice \(flakePrice)")
        print ("flakeParty \(flakeParty)")
        print ("flakePartyAmount \(flakePartyAmount)")
        print ("flakeMembers \(flakeUsers)")
        flakeTitle = String(basicFlakeTitle.text!)
        flakeDetails = String(basicFlakeDetails.text!)
        ID = pageID + 1
        flakeID = flakeIdentification
        current = flakeList.count-1
        let anotherUser = flakeUsers.joined(separator: ",")
        
        /************* Firebase database ****************/
        ref = Database.database().reference()
        let postFlake = [
            "flakeID": "\(flakeID)", //add username to database
            "flakeTitle": "\(flakeTitle)",
            "flakeDetails": "\(flakeDetails)", //add password to database
            "flakeDate": "\(flakeDate)", //add empty flakes to database
            "flakeLocation":  "\(flakeLocation)", //add username to database
            "flakePrice": "\(String(flakePrice))", //add password to database
            "flakeParty": "\(flakeParty)", //add empty flakes to database
            "amountPaid": "0",
            "totalAmountPaid": "0",
            "flakeMembers": "\(anotherUser)" //add all flakeMembers to flake
            ] as [String : Any]
        ref?.child("flakes/flake\(flakeIdentification)").setValue(postFlake) //post all account info into UserAccount database
        if flakeTitle != "" || flakeDate != "" || flakeLocation != "" || flakePrice != 0 {
            /*********************** Do NOT touch (Adding to Fire DB) ***********************/
            newFlakes = "" //clear new flakes
            //print("flakeHolder \(flakeHolder)")
            newFlakes = flakeHolder + "," + String(flakeID)
            //print("new flakeID to add \(String(flakeID))")
            //print("the new flake \(newFlakes)")
            ref?.child("userAccounts/\(uid)/flakeIds").setValue(newFlakes)
            flakeID += 1 //update date to new flake
            ref?.child("flakeIdentification/flakeIdentification").setValue(String(flakeID))
            //dump(newFlakes)
            flakeHolder = newFlakes //save flakes
            newFlakes = "" //clear new flakes
            /***********************Do NOT touch***********************/
            flakeListHolder.removeAll()
            flakeList.removeAll()
            tempList.removeAll()
            currentFlake = ""
            flakeListLength += 1
            let postPaid = [
                "pricePaid": "0" //add username to database
                ] as [String : Any]
            self.ref?.child("flakePots/\("flake" + String(flakeID - 1))/members/\(uid)").updateChildValues(postPaid) //post all account info into UserAccount database
            addUserDB()
        }
    }
    
    func addUserDB(){
        for (index,usr) in flakeUsers.enumerated() { //for loop for all friends added
            print(index)
            let user = String(usr)
            ref?.child("userAccounts").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let artistObject = artists.value as? [String: AnyObject]
                    flakeIds  = artistObject?["flakeIds"] as! String
                    flakeUserAccounts  = artistObject?["userID"] as! String
                    let flakeHolder:String = flakeIds + "," + String(flakeID - 1)
                    if (flakeUserAccounts == user){
                        //print("current user \(user)")
                        let postIds = [
                            "flakeIds": "\(flakeHolder)" //add username to database
                            ] as [String : Any]
                        self.ref?.child("userAccounts/\(flakeUserAccounts)").updateChildValues(postIds) //post all account info into UserAccount database
                        let postPaid = [
                            "pricePaid": "0" //add username to database
                            ] as [String : Any]
                        self.ref?.child("flakePots/\("flake" + String(flakeID - 1))/members/\(flakeUserAccounts)").setValue(postPaid) //post all account info into UserAccount database
                        let postTotalAmountPaid = [
                            "pot": "0" //add username to database
                            ] as [String : Any]
                        self.ref?.child("flakePots/\("flake" + String(flakeID - 1))/totalAmountPaid").setValue(postTotalAmountPaid) //post all account info into UserAccount database
                        return
                    }else{
                        print("\(user)")
                    }
                }
            })
        }
        flakeUsers.removeAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{//displays cells
        var cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! userCell?
        if cell == nil {
            tableView.register(userCell.classForCoder(), forCellReuseIdentifier: "userCell")
            cell = userCell(style: UITableViewCellStyle.default, reuseIdentifier: "userCell")
        }
        if let label = cell?.userName{ 
            label.text = userList[indexPath.row].userName
        }
        else{
            cell?.userName?.text = userList[indexPath.row].userName
        }
        return(cell)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //add user if clicked
        addUsers = String(userList[indexPath.row].userID)
        flakeUsers.append(addUsers)
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { //Remove user if clicked
        addUsers = String(userList[indexPath.row].userID)
        flakeUsers.removeAll { $0 == addUsers }
    }
    
    //Hide keyboard when the users touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
extension UITextField{
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}
