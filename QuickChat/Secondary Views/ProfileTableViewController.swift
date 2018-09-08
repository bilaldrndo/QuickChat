//
//  ProfileTableViewController.swift
//  QuickChat
//
//  Created by Bilal on 7/23/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import ProgressHUD

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var blockUserBtn: UIButton!
    
    var user: FUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    // MARK: - IBActions
    
    @IBAction func callBtnPressed(_ sender: Any) {
        print("call user \(user!.fullname)")
    }
    @IBAction func chatBtnPressed(_ sender: Any) {
        if !checkBlockStatus(withUser: user!) {
            let chatVC = ChatViewController()
            chatVC.titleName = user!.firstname
            chatVC.membersToPush = [FUser.currentId(), user!.objectId]
            chatVC.memberIds = [FUser.currentId(), user!.objectId]
            chatVC.chatRoomId = startPrivateChat(user1: FUser.currentUser()!, user2: user!)
            chatVC.isGroup = false
            chatVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(chatVC, animated: true)
        } else {
            ProgressHUD.showError("This user is not avilable for chat!")
        }
    }
    @IBAction func blockBtnPressed(_ sender: Any) {
        var currentBlockedIds = FUser.currentUser()!.blockedUsers
        
        if currentBlockedIds.contains(user!.objectId) {
            currentBlockedIds.remove(at: currentBlockedIds.index(of: user!.objectId)!)
        } else {
            currentBlockedIds.append(user!.objectId)
        }
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID : currentBlockedIds]) { (error) in
            if error != nil {
                print("error updating user\(error!.localizedDescription)")
                return
            }
            self.updateBlockStatus()
        }
        
        blockUser(userToBlock: user!)
    }
    
    //MARK: - Setup UI
    
    func setupUI() {
        if user != nil {
            self.title = "Profile"
            fullNameLbl.text = user!.fullname
            phoneNumberLbl.text = user!.phoneNumber
            
            updateBlockStatus()
            
            imageFromData(pictureData: user!.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.avatarImgView.image = avatarImage!.circleMasked
                }
            }
        }
    }
    
    func updateBlockStatus() {
        if user!.objectId != FUser.currentId() {
            blockUserBtn.isHidden = false
            messageBtn.isHidden = false
            callBtn.isHidden = false
        } else {
            blockUserBtn.isHidden = true
            messageBtn.isHidden = true
            callBtn.isHidden = true
        }
        
        if FUser.currentUser()!.blockedUsers.contains(user!.objectId) {
            blockUserBtn.setTitle("Unblock User", for: .normal)
        } else {
            blockUserBtn.setTitle("Block User", for: .normal)
        }
        
    }

}
