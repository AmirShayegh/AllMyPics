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

    let cellReuseIdentifier = "ResultCell"
    let cellXibName = "RecultCollectionViewCell"

    var multiSelectResult = [PHAsset]()

    lazy var galleryVC: ChooseImageViewController = {
        let storyboard = UIStoryboard(name: "ChooseImage", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: "ChooseImage") as! ChooseImageViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        NotificationCenter.default.addObserver(forName: .selectedImages, object: nil, queue: nil, using:catchSelectedImages)
    }

    func catchSelectedImages(notification:Notification) -> Void {
//        let phAssets: [PHAsset] = (notification.userInfo!["name"] as! [PHAsset])
        self.multiSelectResult = (notification.userInfo!["name"] as! [PHAsset])
        self.collectionView.reloadData()
//        print("got back \(phAssets.count) images")
    }
    
    @IBAction func goToChoose(_ sender: Any) {
        self.present(galleryVC, animated: true, completion: nil)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func setUpCollectionView() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(UINib(nibName: cellXibName, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)

        // set size of cells
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.itemSize = AssetManager.sharedInstance.getThumbnailSize()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return multiSelectResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : RecultCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! RecultCollectionViewCell
        cell.setUp(phAsset: multiSelectResult[indexPath.row])
        return cell
    }
    

}

