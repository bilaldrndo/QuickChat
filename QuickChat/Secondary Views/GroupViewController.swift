//
//  GroupViewController.swift
//  QuickChat
//
//  Created by Bilal on 9/3/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import ProgressHUD

class GroupViewController: UIViewController {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet var avatarTapGesture: UITapGestureRecognizer!
    
    var group: NSDictionary!
    
    var groupIcon: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImgView.isUserInteractionEnabled = true
        avatarImgView.addGestureRecognizer(avatarTapGesture)
        
        setUpUI()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Invite Users", style: .plain, target: self, action: #selector(self.inviteUsers))]
        
    }
    
    //MARK: IBActions
    
    @IBAction func cameraIconPressed(_ sender: Any) {
        showIconOptions()
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        showIconOptions()
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        var withValues : [String : Any]!
        
        if nameTxtField.text != "" {
            withValues = [kNAME : nameTxtField.text!]
        } else {
            ProgressHUD.showError("Name is required!")
            return
        }
        
        let avatarData = UIImageJPEGRepresentation(avatarImgView.image!, 0.7)
        let avatarString = avatarData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        withValues = [kNAME : nameTxtField.text!, kAVATAR : avatarString]
        
        Group.updateGroup(groupId: group[kGROUPID] as! String, withValues: withValues)
        
        withValues = [kWITHUSERFULLNAME : nameTxtField.text!, kAVATAR : avatarString]
        
        updateExistingRecentWithNewValues(chatRoomId: group[kGROUPID] as! String, members: group[kMEMBERS] as! [String], withValues: withValues)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func inviteUsers() {
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteUsersTableView") as! InviteUserTableViewController
        userVC.group = group
        
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    //MARK: Helpers
    
    func setUpUI() {
        self.title = "Group"
        nameTxtField.text = group[kNAME] as? String
        
        imageFromData(pictureData: group[kAVATAR] as! String) { (avatarImage) in
            if avatarImage != nil {
                self.avatarImgView.image = avatarImage!.circleMasked
            }
        }
    }
    
    func showIconOptions() {
        let optionMenu = UIAlertController(title: "Choose group icon", message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Take/Choose photo", style: .default) { (alert) in
            print("camer")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            print("cancel")
        }
        
        if groupIcon != nil {
            let resetAction = UIAlertAction(title: "Reset", style: .default) { (alert) in
                self.groupIcon = nil
                self.avatarImgView.image = UIImage(named: "cameraIcon")
                self.editBtn.isHidden = true
            }
            optionMenu.addAction(resetAction)
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(cancelAction)
        
        //for iPad not to crash
        if ( UI_USER_INTERFACE_IDIOM() == .pad) {
            if let currentPopoverpresentationcontroller = optionMenu.popoverPresentationController {
                currentPopoverpresentationcontroller.sourceView = editBtn
                currentPopoverpresentationcontroller.sourceRect = editBtn.bounds
                
                currentPopoverpresentationcontroller.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
            }
        } else {
            self.present(optionMenu, animated: true, completion: nil)
        }
        
    }
}
