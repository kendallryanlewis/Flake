//
//  launchScreenViewController.swift
//  Flake
//
//  Created by Kendall Lewis on 8/30/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseDatabase
import FirebaseAuth

var idLocation:String = ""
var userFlakeArray: [Int] = []
var second = [9,8]
var uid = ""
var newFlakes:String = ""

class launchScreenViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        newFlakes = ""
        getUserFlakes() //Get user flakes
        for i in userFlakeArray.enumerated() {
            print (userFlakeArray)
        }
        dump(userFlakeArray)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.performSegue(withIdentifier: "launchScreenSegue", sender: self)
        }
    }
    func getUserFlakes(){
        //userFlakeArray.removeAll()
        let userID = Auth.auth().currentUser
        if (userID != nil) {
            uid = (userID?.uid)!
        }
        idLocation = "userAccounts/\(uid)/flakeIds" //firebase file flocation
        ref?.child(idLocation).observe(.value, with: { (snapshot) in //gather user flake list from firebase
            let post = snapshot.value as? String
            if let actualPost = post{
                self.Identification = actualPost
                //print("This is \(self.Identification)")
            }
            for int in self.Identification {
                if String(int) != ","{
                    self.chrInteger = Int(String(chr))! //convert to int
                    //print(self.chrInteger)
                    userFlakeArray.append(self.chrInteger) //add number to array
                    second.append(self.chrInteger)
                    self.newName = "flake\(self.chrInteger)" //set name to flake#
                    //print(self.newName)
                    self.databaseFlakeData() //gather firebase data for flakes
                    //print("This is the flake array \(userFlakeArray)")
                    if newFlakes != ""{
                        newFlakes = "\(newFlakes),\(String(chr))"
                    }else{
                        newFlakes = "\(String(chr))"
                    }
                }
            }
        })
        print(second)
    }
    func databaseFlakeData(){
        ref?.child("flakes/\(newName)").observe(.childAdded, with: { (snapshot) in //Retrieve flake
            let post = snapshot.value as? String
            if let actualPost = post{
                //self.flakeListFB.append(actualPost)
                //print(actualPost)
                self.postIndex += 1
                self.firebaseDataIndex = "firebase\(self.postIndex)"
                if self.firebaseDataIndex == "firebase1"{
                    self.firebaseData1 = Int(actualPost)!
                    //print(self.firebaseData1)
                }else if self.firebaseDataIndex == "firebase2"{
                    self.firebaseData2 = actualPost
                    //print(self.firebaseData2)
                }else if self.firebaseDataIndex == "firebase3"{
                    self.firebaseData3 = actualPost
                    //print(self.firebaseData3)
                }else if self.firebaseDataIndex == "firebase4"{
                    self.firebaseData4 = Int(actualPost)!
                    //print(self.firebaseData4)
                }else if self.firebaseDataIndex == "firebase5"{
                    self.firebaseData5 = actualPost
                    //print(self.firebaseData5)
                }else if self.firebaseDataIndex == "firebase6"{
                    self.firebaseData6 = Int(actualPost)!
                    //print(self.firebaseData6)
                }else if self.firebaseDataIndex == "firebase7"{
                    self.firebaseData7 = Int(actualPost)!
                    //print(self.firebaseData7)
                }else if self.firebaseDataIndex == "firebase8"{
                    self.firebaseData8 = actualPost
                    //print(self.firebaseData8)
                }else if self.firebaseDataIndex == "firebase9"{
                    self.firebaseData9 = Int(actualPost)!
                    //print(self.firebaseData9)
                }
            }
            if self.postIndex == 9 {
                flakeList.append(flakeDisplay(flakeID: self.firebaseData4, flakeTitle: self.firebaseData8, flakeDetails: self.firebaseData3, flakeDate: self.firebaseData2, flakeLocation: self.firebaseData5, flakePrice: self.firebaseData7, flakeParty: self.firebaseData6, amountPaid: self.firebaseData1, totalAmountPaid: self.firebaseData9))
                self.postIndex = 0
            }
        })
    }
}
