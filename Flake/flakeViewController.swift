//
//  flakeViewController.swift
//  
//
//  Created by Kendall Lewis on 7/5/18.
//

import UIKit
var messageList = [Message(userName: "Peter", userMessage: "Hey, Whats!"), Message(userName: "Peter", userMessage: "Hey, Whats!"), Message(userName: "Peter", userMessage: "Hey, Whats!"), Message(userName: "Peter", userMessage: "Hey, Whats!")]

class Message {
    var userName = ""
    var userMessage = ""
    init(userName: String, userMessage: String) {
        self.userName = userName
        self.userMessage = userMessage
    }
}

class messageCell: UITableViewCell{
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMessage: UITextView!
}

class flakeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var remainingAmount: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var moneyAmount: UITextField!
    
    var flakeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        definesPresentationContext = true
        tableView.backgroundColor = UIColor.clear
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{//displays cells
        var cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! messageCell?
        if cell == nil {
            tableView.register(messageCell.classForCoder(), forCellReuseIdentifier: "messageCell") //Cell name "searchCell"
            cell = messageCell(style: UITableViewCellStyle.default, reuseIdentifier: "messageCell")
        }
        if let label = cell?.userName{ //populate cell with drink name
            label.text = messageList[indexPath.row].userName
        }
        else{
            cell?.userName?.text = messageList[indexPath.row].userName
        }
        if let label = cell?.userMessage{ //populate cell with drink name
            label.text = messageList[indexPath.row].userMessage
        }
        else{
            cell?.userMessage?.text = messageList[indexPath.row].userMessage
        }
        return(cell)!
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
    @IBAction func addPayment(_ sender: Any) {
        let addCurrentPayment = Int(moneyAmount.text!)
        var flakeIndex = pageID - 1
        if flakeIndex <= 0 {
            flakeIndex = 0
        }else{
            
        }
        if addCurrentPayment != nil{
            print("Added payment \(addCurrentPayment)")
            flakeList[flakeIndex].amountPaid += addCurrentPayment!
            flakeList[flakeIndex].totalAmountPaid += addCurrentPayment!
            performSegue(withIdentifier: "flakeToMainSegue", sender: self)//segues to the main page
            
            print("flake page Id \(pageID)")
            print("flake index \(flakeIndex)")
        
        }
    }
}

