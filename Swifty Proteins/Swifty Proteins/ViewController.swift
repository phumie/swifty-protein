//
//  ViewController.swift
//  Swifty Proteins
//
//  Created by Phumudzo NEVHUTALA on 2018/10/23.
//  Copyright © 2018 Phumudzo NEVHUTALA. All rights reserved.
//

import UIKit
import LocalAuthentication
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginBtn(_ sender: Any) {
        login();
    }
    
    @IBAction func touchBtn(_ sender: Any) {
        if touchID() == 0 {
            self.showAlertController("Touch ID Authentication Succeeded")
        }
        else if touchID() == 1 {
            self.showAlertController("Touch ID Authentication Failed")
        }
        else if touchID() == -1 {
            let disableMyButton = sender as? UIButton
            disableMyButton?.isEnabled = false
        }
    }
    
    func login() {
//        if (self.username.text == "" || self.password.text == ""){
//            self.showAlertController("Username or Password cannot be empty.")
//            return;
//        }
//        else{
//            Auth.auth().signIn(withEmail: self.username.text!, password: self.password.text!) { (user, error) in
//                if error == nil {
//                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProteinListView")
//                    self.present(newViewController, animated: true, completion: nil)
//                    print("successfully logged in");
//                }
//                else{
//                    self.showAlertController("Authentication failed. Try again.")
//                }
//            }
//        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProteinListView")
        self.present(newViewController, animated: true, completion: nil)
        print("successfully logged in");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func touchID() -> Int {
        let context = LAContext()
        var error: NSError?
        var ret = -1;
        
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(succes, error) in
                    if succes {
                        ret = 0;
                    }
                    else {
                        ret = 1;
                    }
                    } as (Bool, Error?) -> Void)
        }
        else {
            ret = -1;
        }
        return ret;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

