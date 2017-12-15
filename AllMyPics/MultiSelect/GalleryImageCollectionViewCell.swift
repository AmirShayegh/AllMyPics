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

    @IBOutlet weak var picFrame: UIView!
    @IBOutlet weak var container: UIView!
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
        style()
    }

    func style() {
        isSelectedView.layer.cornerRadius = isSelectedView.frame.height/2
        container.layer.borderColor = container.backgroundColor?.cgColor
        container.layer.borderWidth = 2
        container.layer.cornerRadius = 5
        picFrame.layer.borderWidth = 2
        picFrame.layer.borderColor = container.backgroundColor?.cgColor
        picFrame.layer.cornerRadius = 5
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

    func setUp(selectedIndexes: [Int], indexPath: IndexPath, phAsset: PHAsset) {
        self.deSelect()
        self.isSelectedLabel.text = ""
        if selectedIndexes.contains(indexPath.row) {
            if let index = selectedIndexes.index(of: indexPath.row) {
                selectCell(index: index)
            }
        }

        setImageFrom(phAsset: phAsset)
    }

    func hasImage() -> Bool{
        return imageView.image != nil
    }

    func setImageFrom(phAsset: PHAsset) {
        AssetManager.sharedInstance.phManager?.requestImage(for: phAsset,
                                                            targetSize: AssetManager.sharedInstance.getThumbnailSize(),
                                                            contentMode: .aspectFit,
                                                            options:  AssetManager.sharedInstance.getPHImageRequestOptions(),
                                                            resultHandler: { (image, info) in
            if let image = image {
                self.imageView.image = image
            }
        })
    }
}
