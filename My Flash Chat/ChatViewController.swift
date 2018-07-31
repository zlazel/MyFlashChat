//
//  ChatViewController.swift
//  My Flash Chat
//
//  Created by AhmedZlazel on 6/23/18.
//  Copyright © 2018 AhmedZlazel. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!

    var messageArray: [Message] = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        // messageTableView  delegate
        messageTableView.delegate = self
        messageTableView.dataSource = self
        // messageTextField delegate
        messageTextField.delegate = self
        
        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        // tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)
        
        configureTableView()
        retriveMessage()
        messageTableView.separatorStyle = .none
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func tableViewTapped(){
        messageTextField.endEditing(true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = #imageLiteral(resourceName: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String!{
        cell.avatarImageView.backgroundColor = UIColor.flatMint()
        cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }else{
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    

    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Going up ")
        heightConstraint.constant = 320
        view.layoutIfNeeded()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
        print("Going down ")
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        sendButton.isEnabled = false
        messageTextField.isEnabled = false
        messageTextField.endEditing(true)
        
        let messagesDB = Database.database().reference().child("Messages")
        let messagesDictionary = ["Sender":Auth.auth().currentUser?.email,
                                  "MessageBody":messageTextField.text!]
        messagesDB.childByAutoId().setValue(messagesDictionary){
            (error, reference) in
            if error != nil{
                print(error!)
            }else{
                print("Message saved successfully")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
        }
    }
    
    func retriveMessage(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded){(snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let message = Message()
            message.messageBody = snapshotValue["MessageBody"]!
            message.sender = snapshotValue["Sender"]!
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
           navigationController?.popToRootViewController(animated: true)
            print("Singing out Scuccess !!!")
        }catch{
            print("Singing out failed !!!")
        }
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
