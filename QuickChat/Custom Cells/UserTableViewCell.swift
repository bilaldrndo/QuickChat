//
//  UserTableViewCell.swift
//  QuickChat
//
//  Created by Bilal on 7/22/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit

protocol UserTableViewCellDelegate {
    func didTapAvatarImage(indexPath: IndexPath)
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var fullNAmeLbl: UILabel!
    
    var indexPath: IndexPath!
    
    var delegate: UserTableViewCellDelegate?
    
    let tapGestureReckognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestureReckognizer.addTarget(self, action: #selector(self.avatarTap))
        avatarImgView.isUserInteractionEnabled = true
        avatarImgView.addGestureRecognizer(tapGestureReckognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func generateCellWith(fUser: FUser, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        self.fullNAmeLbl.text = fUser.fullname
        
        if fUser.avatar != "" {
            imageFromData(pictureData: fUser.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.avatarImgView.image = avatarImage!.circleMasked
                }
            }
        }
    }
    
    @objc func avatarTap() {
        delegate!.didTapAvatarImage(indexPath: indexPath)
        
    }

}
