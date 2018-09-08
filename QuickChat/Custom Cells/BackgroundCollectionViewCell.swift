//
//  BackgroundCollectionViewCell.swift
//  QuickChat
//
//  Created by Bilal on 8/28/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(image: UIImage) {
        self.imageView.image = image
    }
}
