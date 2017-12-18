//
//  ViewController.swift
//  AllMyPics
//
//  Created by Amir Shayegh on 2017-12-14.
//  Copyright © 2017 Amir Shayegh. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let resultCellReuseIdentifier = "ResultCell"
    let resultCellXibName = "RecultCollectionViewCell"
    let mediaCellReuseIdentifier = "MediaOptionCell"
    let mediaCellXibName = "OptionCollectionViewCell"

    let OPTIONS_COUNT = 2

    var multiSelectResult = [PHAsset]()

    let galleryManager = GalleryManager()

    override func viewDidLoad() {
        super.viewDidLoad()
//        galleryManager.setColors(bg_hex: "004b8d", utilBarBG_hex: "fcb813", buttonText_hex: "ffffff", loadingBG_hex: "083760", loadingIndicator_hex: "ffffff")
        setUpCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        updateImageResults()
    }

    func gotToGallery() {
        self.present(galleryManager.getVC(), animated: true, completion: nil)
    }


    func updateImageResults() {
        let newResults = galleryManager.multiSelectResult
        for asset in newResults {
            if !self.multiSelectResult.contains(asset) {
                multiSelectResult.append(asset)
            }
        }
        self.collectionView.reloadData()
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func setUpCollectionView() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(UINib(nibName: resultCellXibName, bundle: nil), forCellWithReuseIdentifier: resultCellReuseIdentifier)
        self.collectionView.register(UINib(nibName: mediaCellXibName, bundle: nil), forCellWithReuseIdentifier: mediaCellReuseIdentifier)

        // set size of cells
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.itemSize = CGSize(width: 100, height: 100)

//        layout.itemSize = AssetManager.sharedInstance.getThumbnailSize()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OPTIONS_COUNT + multiSelectResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row > 1 {
            let cell : RecultCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: resultCellReuseIdentifier, for: indexPath) as! RecultCollectionViewCell
            cell.setUp(phAsset: multiSelectResult[indexPath.row - 2])
            return cell
        } else {
             let cell : OptionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifier, for: indexPath) as! OptionCollectionViewCell
            if indexPath.row == 0 {
                cell.imsgeView.image = #imageLiteral(resourceName: "galleryicon")
            } else {
                cell.imsgeView.image = #imageLiteral(resourceName: "cameraicon")
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < 2 {
            if indexPath.row == 0 {
                // go to gallery
                gotToGallery()
            } else {
                // go to camera
            }
        }
    }
}

