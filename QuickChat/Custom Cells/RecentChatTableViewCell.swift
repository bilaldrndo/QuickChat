//
//  RecentChatTableViewCell.swift
//  QuickChat
//
//  Created by Bilal on 7/25/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit

protocol RecentChatTableViewCellDelegate {
    func didTapAvatarImage(indexPath: IndexPath)
}

class RecentChatTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var lastMessageLbl: UILabel!
    @IBOutlet weak var messageCounter: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var messageCounterBackgroundView: UIView!

    var indexPath: IndexPath!
    
    let tapGesture = UITapGestureRecognizer()
    
    var delegate: RecentChatTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageCounterBackgroundView.layer.cornerRadius = messageCounterBackgroundView.frame.width / 2
        tapGesture.addTarget(self, action: #selector(self.avatarTap))
        avatarImgView.isUserInteractionEnabled = true
        avatarImgView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Generate Cell
    
    func generateCell(recentChat: NSDictionary, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.fullNameLbl.text = recentChat[kWITHUSERFULLNAME] as? String
        
        let decryptedText = Encryption.decryptText(chatRoomId: recentChat[kCHATROOMID] as! String, encryptedMessage: recentChat[kLASTMESSAGE] as! String)
        
        self.lastMessageLbl.text = decryptedText
        self.messageCounter.text = recentChat[kCOUNTER] as? String
        
        if let avatarString = recentChat[kAVATAR] {
            imageFromData(pictureData: avatarString as! String) { (avatarImage) in
                if avatarImage != nil {
                    self.avatarImgView.image = avatarImage!.circleMasked
                }
            }
        }
        
        if recentChat[kCOUNTER] as! Int != 0 {
            self.messageCounter.text = "\(recentChat[kCOUNTER] as! Int)"
            self.messageCounterBackgroundView.isHidden = false
            self.messageCounter.isHidden = false
        } else {
            self.messageCounterBackgroundView.isHidden = true
            self.messageCounter.isHidden = true
        }
        
        var date: Date!
        
        if let created = recentChat[kDATE] {
            if (created as! String).count != 14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)!
            }
        } else {
            date = Date()
        }
        self.dateLbl.text = timeElapsed(date: date)
    }
    
    @objc func avatarTap() {
        print("avatar tap \(indexPath)")
        delegate?.didTapAvatarImage(indexPath: indexPath)
    }
}






