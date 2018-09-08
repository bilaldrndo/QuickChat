//
//  NewGroupViewController.swift
//  QuickChat
//
//  Created by Bilal on 8/30/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import ProgressHUD

class NewGroupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GroupMemberCollectionViewCellDelegate {

    @IBOutlet weak var editAvatarBtn: UIButton!
    @IBOutlet weak var groupImgView: UIImageView!
    @IBOutlet weak var groupNameTxtField: UITextField!
    @IBOutlet weak var participantsLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var imageTapGesture: UITapGestureRecognizer!
    
    var memberIds: [String] = []
    var allMembers: [FUser] = []
    var groupIcon: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        groupImgView.isUserInteractionEnabled = true
        groupImgView.addGestureRecognizer(imageTapGesture)
        
        updateParticipantsLbl()
    }
    
    //MARK: CollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GroupMemberCollectionViewCell
        cell.delegate = self
        
        cell.generateCell(user: allMembers[indexPath.row], indexPath: indexPath)
        
        return cell
    }
    
    //IBActions
    
    @objc func createBtnPressed(_ sender: Any) {
        if groupNameTxtField.text != "" {
            memberIds.append(FUser.currentId())
            
            let avatarData = UIImageJPEGRepresentation(UIImage(named: "groupIcon")!, 0.7)!
            var avatar = avatarData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            if groupIcon != nil {
                let avatarData = UIImageJPEGRepresentation(groupIcon!, 0.7)!
                var avatar = avatarData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            }
            
            let groupId = UUID().uuidString
            
            //create group
            
            let group = Group(groupId: groupId, subject: groupNameTxtField.text!, ownerID: FUser.currentId(), members: memberIds, avatar: avatar)
            
            group.saveGroup()
            
            startGroupChat(group: group)
        
        
            let chatVC = ChatViewController()
            chatVC.title = group.groupDictionary[kNAME] as? String
            chatVC.memberIds = group.groupDictionary[kMEMBERS] as! [String]
            chatVC.membersToPush = group.groupDictionary[kMEMBERS] as! [String]
            chatVC.chatRoomId = groupId
            chatVC.isGroup = true
            chatVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(chatVC, animated: true)
    
        } else {
            ProgressHUD.showError("Name is Required")
        }
    }
    
    @IBAction func groupImageTapped(_ sender: Any) {
        showIconOptions()
    }
    
    @IBAction func editAvatarBtnPressed(_ sender: Any) {
        showIconOptions()
    }
    
    //MARK: GroupMemberCollectionViewCellDelegate
    
    func didClickDeleteButton(indexPath: IndexPath) {
        allMembers.remove(at: indexPath.row)
        memberIds.remove(at: indexPath.row)
        
        collectionView.reloadData()
        updateParticipantsLbl()
    }
    
    //MARK: Helper Functions
    
    func updateParticipantsLbl() {
        participantsLbl.text = "PARTICIPANTS: \(allMembers.count)"
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(self.createBtnPressed))]
        
        self.navigationItem.rightBarButtonItem?.isEnabled = allMembers.count > 0
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
                self.groupImgView.image = UIImage(named: "cameraIcon")
                self.editAvatarBtn.isHidden = true
            }
            optionMenu.addAction(resetAction)
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(cancelAction)
        
        //for iPad not to crash
        if ( UI_USER_INTERFACE_IDIOM() == .pad) {
            if let currentPopoverpresentationcontroller = optionMenu.popoverPresentationController {
                currentPopoverpresentationcontroller.sourceView = editAvatarBtn
                currentPopoverpresentationcontroller.sourceRect = editAvatarBtn.bounds
                
                currentPopoverpresentationcontroller.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
            }
        } else {
            self.present(optionMenu, animated: true, completion: nil)
        }

    }
}












