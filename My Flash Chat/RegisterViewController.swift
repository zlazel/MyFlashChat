//
//  RegisterViewController.swift
//  My Flash Chat
//
//  Created by AhmedZlazel on 6/23/18.
//  Copyright © 2018 AhmedZlazel. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

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
    
    @IBAction func registerPresses(_ sender: UIButton) {
        SVProgressHUD.show()

        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user,error) in
            if error != nil{
                print(error!)
            }else
            {
                print("Registeration Successful!")

                SVProgressHUD.dismiss()

                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
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
