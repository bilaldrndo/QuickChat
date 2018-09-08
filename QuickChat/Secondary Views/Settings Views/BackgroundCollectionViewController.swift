//
//  BackgroundCollectionViewController.swift
//  QuickChat
//
//  Created by Bilal on 8/28/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import ProgressHUD

class BackgroundCollectionViewController: UICollectionViewController {
    
    var backgrounds : [UIImage] = []
    let userDefaults = UserDefaults.standard
    
    private let imageNamesArray = ["bg0", "bg1", "bg2", "bg3", "bg4", "bg5", "bg6", "bg7", "bg8", "bg9", "bg10", "bg11"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageArray()
        
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(self.resetToDefault))
        self.navigationItem.rightBarButtonItem = resetButton
    }

    //MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgrounds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BackgroundCollectionViewCell
        
        cell.generateCell(image: backgrounds[indexPath.row])
    
        return cell
    }

    //MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userDefaults.set(imageNamesArray[indexPath.row], forKey: kBACKGROUNDIMAGE)
        userDefaults.synchronize()
        
        ProgressHUD.showSuccess("Set")
    }
    
    //IBActions
    
    @objc func resetToDefault() {
        userDefaults.removeObject(forKey: kBACKGROUNDIMAGE)
        userDefaults.synchronize()
        ProgressHUD.showSuccess("Set")
    }

    //MARK: Helper
    
    func setupImageArray() {
        for imageName in imageNamesArray {
            let image = UIImage(named: imageName)
            
            if image != nil {
                backgrounds.append(image!)
            }
        }
    }
}






