//
//  GroupMemberCollectionViewCell.swift
//  QuickChat
//
//  Created by Bilal on 8/30/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit

protocol GroupMemberCollectionViewCellDelegate {
    func didClickDeleteButton(indexPath: IndexPath)
}

class GroupMemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    
    var indexPath: IndexPath!
    var delegate: GroupMemberCollectionViewCellDelegate?
    
    func generateCell(user: FUser, indexPath: IndexPath) {
        self.indexPath = indexPath
        nameLbl.text = user.firstname
        
        if user.avatar != "" {
            imageFromData(pictureData: user.avatar) { (avatarImage) in
                if avatarImage != nil {
                    avatarImgView.image = avatarImage!.circleMasked
                }
            }
        }
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        delegate!.didClickDeleteButton(indexPath: indexPath)
    }
    
}
