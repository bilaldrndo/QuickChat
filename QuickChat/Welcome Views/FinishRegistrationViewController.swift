//
//  FinishRegistrationViewController.swift
//  QuickChat
//
//  Created by Bilal on 7/21/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import ProgressHUD

class FinishRegistrationViewController: UIViewController {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var surnameTxtField: UITextField!
    @IBOutlet weak var coutryTxtField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    
    var email: String!
    var password: String!
    var avatar: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(email,password)
    }
    
    @IBAction func cancleBtnPessed(_ sender: Any) {
        cleanTextField()
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        ProgressHUD.show("Registering...")
        
        if nameTxtField.text != "" && surnameTxtField.text != "" && coutryTxtField.text != "" && cityTextField.text != "" && phoneTxtField.text != "" {
            
            FUser.registerUserWith(email: email!, password: password!, firstName: nameTxtField.text!, lastName: surnameTxtField.text!) { (error) in
                if error != nil {
                    
                    ProgressHUD.dismiss()
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                self.registerUser()
                
            }
            
        } else {
            ProgressHUD.showError("All fields are required")
        }
    }
    
    func registerUser() {
        let fullName = nameTxtField.text! + " " + surnameTxtField.text!
        var tempDictionary : Dictionary = [kFIRSTNAME : nameTxtField.text!, kLASTNAME: surnameTxtField.text!, kFULLNAME: fullName, kCOUNTRY: coutryTxtField.text!, kCITY: cityTextField.text!, kPHONE: phoneTxtField.text!] as [String : Any]
        
        if avatarImgView.image == nil {
            
            imageFromInitials(firstName: nameTxtField.text!, lastName: surnameTxtField.text!) { (avatarInitials) in
                
                let avatarIMG = UIImageJPEGRepresentation(avatarInitials, 0.7)
                let avatar = avatarIMG!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                tempDictionary[kAVATAR] = avatar
                
                self.finishRegistration(withValues: tempDictionary)
            }
        } else {
            let avatarData = UIImageJPEGRepresentation(avatarImgView.image!, 0.7)
            let avatar = avatarData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            tempDictionary[kAVATAR] = avatar
            
            self.finishRegistration(withValues: tempDictionary)
        }
    }
    
    func finishRegistration(withValues: [String : Any]) {
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error?.localizedDescription)
                }
                return
            }
            ProgressHUD.dismiss()
            self.goToApp()
        }
    }
    
    func goToApp() {
        cleanTextField()
        dismissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID: FUser.currentId()])
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        self.present(mainView, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func cleanTextField() {
        nameTxtField.text = ""
        surnameTxtField.text = ""
        coutryTxtField.text = ""
        cityTextField.text = ""
        phoneTxtField.text = ""
    }
}

