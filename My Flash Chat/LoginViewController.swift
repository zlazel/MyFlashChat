//
//  LoginViewController.swift
//  My Flash Chat
//
//  Created by AhmedZlazel on 6/23/18.
//  Copyright © 2018 AhmedZlazel. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    var count = 1
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
       SVProgressHUD.show()
        print("LogIn pressed")
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){(user, error) in
            if error != nil{
                print(error!)
            }else{
                SVProgressHUD.dismiss()
                print("Successfully logged , current user email is: \((Auth.auth().currentUser!.email)!)")
                self.count = self.count + 1
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
         //   SVProgressHUD.dismiss()

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
