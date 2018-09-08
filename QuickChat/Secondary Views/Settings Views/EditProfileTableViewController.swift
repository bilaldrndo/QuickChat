//
//  EditProfileTableViewController.swift
//  QuickChat
//
//  Created by Bilal on 8/28/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import ProgressHUD

class EditProfileTableViewController: UITableViewController {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var surnameNameTxtField: UITextField!
    @IBOutlet weak var emailNameTxtField: UITextField!
    @IBOutlet var avatarTapGestureReckognizer: UITapGestureRecognizer!
    
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        setupUI()
    }

    //MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: IBActions
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if firstNameTxtField.text != "" && surnameNameTxtField.text != "" && emailNameTxtField.text != "" {
            ProgressHUD.show("Saving...")
            
            saveBtn.isEnabled = false
            
            let fullName = firstNameTxtField.text! + " " + surnameNameTxtField.text!
            
            var withValues = [kFIRSTNAME : firstNameTxtField.text!, kLASTNAME : surnameNameTxtField.text!, kFULLNAME : fullName]
            
            if avatarImage != nil {
                let avatarData = UIImageJPEGRepresentation(avatarImage!, 0.7)!
                let avatarString = avatarData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                withValues[kAVATAR] = avatarString
            }
            
            //update current user
            
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                if error != nil {
                    DispatchQueue.main.async {
                        ProgressHUD.showError(error!.localizedDescription)
                        print("Could not update user \(error!.localizedDescription)")
                    }
                    self.saveBtn.isEnabled = true
                    return
                }
                ProgressHUD.showSuccess("Saved")
                self.saveBtn.isEnabled = true
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            ProgressHUD.showError("All fields are required!")
        }
    }
    
    @IBAction func avatarImgViewTapped(_ sender: Any) {
        print("Avatar tap")
    }
    
    //MARK: SetupUI
    
    func setupUI() {
        let currentUser = FUser.currentUser()
        avatarImgView.isUserInteractionEnabled = true
        
        firstNameTxtField.text = currentUser?.firstname
        surnameNameTxtField.text = currentUser?.lastname
        emailNameTxtField.text = currentUser?.email
        
        if currentUser?.avatar != "" {
            imageFromData(pictureData: currentUser!.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.avatarImgView.image = avatarImage!.circleMasked
                }
            }
        }
        
    }
    
}













