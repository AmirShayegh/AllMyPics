//
//  GalleryImageCollectionViewCell.swift
//  imageMultiSelect
//
//  Created by Amir Shayegh on 2017-12-12.
//  Copyright © 2017 Amir Shayegh. All rights reserved.
//

import UIKit
import Photos

class GalleryImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var isSelectedLabel: UILabel!
    @IBOutlet weak var isSelectedView: UIView!

    var asset: PHAsset?

    var cellSelected: Bool = false {
        didSet {
            if cellSelected {select()} else {deSelect()}
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func select() {
        self.isSelectedLabel.isHidden = false
        self.isSelectedView.isHidden = false
    }

    func deSelect() {
        self.isSelectedLabel.isHidden = true
        self.isSelectedView.isHidden = true
    }

    func selectCell(index: Int) {
        self.isSelectedLabel.text = "\(index + 1)"
        cellSelected = true
    }

    func setUp(selectedIndexes: [Int], indexPath: IndexPath, phAsset: PHAsset, primaryColor: UIColor, textColor: UIColor) {
        style(primaryColor: primaryColor, textColor: textColor)
        self.cellSelected = false
        self.deSelect()
        self.isSelectedLabel.text = ""
        
        if selectedIndexes.contains(indexPath.row) {
            if let index = selectedIndexes.index(of: indexPath.row) {
                selectCell(index: index)
            }
        }

        AssetManager.sharedInstance.getImageFromAsset(phAsset: phAsset) { (assetImage) in
            self.imageView.image = assetImage
        }
    }

    func style(primaryColor: UIColor, textColor: UIColor) {
        isSelectedView.backgroundColor = primaryColor
        isSelectedLabel.textColor = textColor
        isSelectedLabel.alpha = 0.8
        isSelectedView.layer.cornerRadius = isSelectedView.frame.height/2
        imageView.layer.borderColor = primaryColor.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 5
    }
}
