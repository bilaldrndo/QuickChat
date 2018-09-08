//
//  WelcomeViewController.swift
//  QuickChat
//
//  Created by Bilal on 7/20/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var repeatPasswordTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        dismissKeyboard()
        if emailTxtField.text != "" && passwordTxtField.text != "" {
            loginUser()
        } else {
            ProgressHUD.showError("Please enter Email and Password")
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        dismissKeyboard()
        if emailTxtField.text != "" && passwordTxtField.text != "" && repeatPasswordTxtField.text != ""{
            if passwordTxtField.text == repeatPasswordTxtField.text {
                registerUser()
            } else {
                ProgressHUD.showError("Passwords don't match")
            }
        } else {
            ProgressHUD.showError("All fields Are Required")
        }

    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    //MARK: Helper Functions
    
    func loginUser() {
        ProgressHUD.show("LOGGING IN...")
        FUser.loginUserWith(email: emailTxtField.text!, password: passwordTxtField.text!) { (error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            self.goToApp()
        }
    }
    
    func registerUser() {
        dismissKeyboard()
        performSegue(withIdentifier: "welcomeToFinishReg", sender: self)
        cleanTextField()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func cleanTextField() {
        emailTxtField.text = ""
        passwordTxtField.text = ""
        repeatPasswordTxtField.text = ""
    }
    
    func goToApp() {
        ProgressHUD.dismiss()
        cleanTextField()
        dismissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID: FUser.currentId()])
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        self.present(mainView, animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "welcomeToFinishReg" {
            let vc = segue.destination as! FinishRegistrationViewController
            vc.email = emailTxtField.text
            vc.password = passwordTxtField.text
        }
    }
}










