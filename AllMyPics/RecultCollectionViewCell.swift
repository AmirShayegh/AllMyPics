//
//  RecultCollectionViewCell.swift
//  AllMyPics
//
//  Created by Amir Shayegh on 2017-12-15.
//  Copyright © 2017 Amir Shayegh. All rights reserved.
//

import UIKit
import Photos

class RecultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(phAsset: PHAsset) {
        AssetManager.sharedInstance.getImageFromAsset(phAsset: phAsset) { (image) in
            self.imageView.image = image
        }
    }

}
