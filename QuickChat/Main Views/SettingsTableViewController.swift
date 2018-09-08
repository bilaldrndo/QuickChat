//
//  SettingsTableViewController.swift
//  QuickChat
//
//  Created by Bilal on 7/22/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var avatarStatusSwitch: UISwitch!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    var avatarSwitchStatus = false
    var firstLoad: Bool?
    
    override func viewWillAppear(_ animated: Bool) {
        if FUser.currentUser() != nil {
            setupUI()
            loadUserDefaults()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()

    }
    
    //MARK: TableViewDelegate
    
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
    
    //MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 5
        }
        return 2
    }
    
    //MARK: IBActions
    
    @IBAction func showAvatarSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
           avatarSwitchStatus = true
        } else {
            avatarSwitchStatus = false
        }
        saveUserDefaults()
    }
    
    @IBAction func clearnCacheBtnPressed(_ sender: Any) {
        do {
            ProgressHUD.showSuccess("Cache succesfuly cleaned!")
            
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentsUrl().path)
            
            for file in files {
                try FileManager.default.removeItem(atPath: "\(getDocumentsUrl().path)/\(file)")
            }
            
        } catch {
            ProgressHUD.showError("Could not delete media files")
        }
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        let text = "Hey lets chat on Secret Chat \(kAPPURL)"
        let objectsToShare: [Any] = [text]
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.setValue("Lets chat on Secret Chat", forKey: "subject")
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        FUser.logOutCurrentUser { (success) in
            if success {
                self.showLoginView()
            }
        }
    }
    
    @IBAction func deleteAccountBtnPressed(_ sender: Any) {
        let optionMenu = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
            self.deleteUser()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
        }
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        //for iPad not to crash
        if ( UI_USER_INTERFACE_IDIOM() == .pad) {
            if let currentPopoverpresentationcontroller = optionMenu.popoverPresentationController {
                currentPopoverpresentationcontroller.sourceView = deleteBtn
                currentPopoverpresentationcontroller.sourceRect = deleteBtn.bounds
                
                currentPopoverpresentationcontroller.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
            }
        } else {
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    func showLoginView() {
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
        self.present(mainView, animated: true, completion: nil)
    }
    
    //MARK: SetupUI
    
    func setupUI() {
        let currentUser = FUser.currentUser()!
        
        fullNameLbl.text = currentUser.fullname
        
        if currentUser.avatar != "" {
            imageFromData(pictureData: currentUser.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.avatarImgView.image = avatarImage!.circleMasked
                }
            }
        }
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLbl.text = version
        }
    }
    
    //MARK: Delete User
    
    func deleteUser() {
        
        //delete locally
        userDefaults.removeObject(forKey: kPUSHID)
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        //deleteFromFirebase
        
        reference(.User).document(FUser.currentId()).delete()
        
        FUser.deleteUser { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError("Could not delete user")
                }
                return
            }
            self.showLoginView()
        }
    }
    
    //MARK: UserDefaults
    
    func saveUserDefaults() {
        userDefaults.set(avatarSwitchStatus, forKey: kSHOWAVATAR)
        userDefaults.synchronize()
    }
    
    func loadUserDefaults() {
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad! {
            userDefaults.set(true, forKey: kFIRSTRUN)
            userDefaults.set(avatarSwitchStatus, forKey: kSHOWAVATAR)
            userDefaults.synchronize()
        }
        avatarSwitchStatus = userDefaults.bool(forKey: kSHOWAVATAR)
        avatarStatusSwitch.isOn = avatarSwitchStatus
    }
}





