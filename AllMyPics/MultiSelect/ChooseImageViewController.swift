//
//  ChooseImageViewController.swift
//  imageMultiSelect
//
//  Created by Amir Shayegh on 2017-12-12.
//  Copyright © 2017 Amir Shayegh. All rights reserved.
//

import UIKit
import Photos

extension Notification.Name {
    static let selectedImages = Notification.Name("selectedImages")
}

class ChooseImageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var loadingContainer: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    var images = [PHAsset]()
    var selectedIndexs = [Int]()
    var cachedImages = [Int: UIImage]()

    let cellReuseIdentifier = "GalleryImageCell"
    let cellXibName = "GalleryImageCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        lockdown()
        style()
        setUpCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(sent), name: .selectedImages, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setData()
        unlock()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.selectedIndexs.removeAll()
    }

    func sendBackImages(images: [PHAsset]) {
        NotificationCenter.default.post(name: .selectedImages, object: self, userInfo: ["name":images])
        unlock()
        closeVC()
    }

    @IBAction func addImages(_ sender: Any) {
        if selectedIndexs.count == 0 {
            closeVC()
        }
        self.lockdown()
        var selectedImages = [PHAsset]()
        for index in selectedIndexs {
            selectedImages.append(images[index])
        }
        sendBackImages(images: selectedImages)
    }

    @IBAction func cancel(_ sender: Any) {
        closeVC()
    }

    func closeVC() {
        self.selectedIndexs.removeAll()
        self.collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }

    @objc func sent() { print("sent back") }

    func lockdown() {
        self.loading.startAnimating()
        self.addButton.isUserInteractionEnabled = false
        self.cancelButton.isUserInteractionEnabled = false
        self.loading.isHidden = false
        self.loadingContainer.isHidden = false
        collectionView.isUserInteractionEnabled = false
    }

    func unlock() {
        self.loading.stopAnimating()
        self.addButton.isUserInteractionEnabled = true
        self.cancelButton.isUserInteractionEnabled = true
        self.loading.isHidden = true
        self.loadingContainer.isHidden = true
        collectionView.isUserInteractionEnabled = true
    }

    func setData() {
        getImages()
    }

    func getImages() {
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        self.images.removeAll()
        let assets = PHAsset.fetchAssets(with: .image, options: options)
        assets.enumerateObjects { (asset, count, stop) in
            self.images.append(asset)
            if self.images.count == assets.count {
                self.images.reverse()
                self.collectionView.reloadData()
            }
        }
        self.collectionView.reloadData()
        let options2 = PHImageRequestOptions()
        options2.isSynchronous = false
        options2.deliveryMode = .opportunistic
        let manager = PHCachingImageManager()
        let size = CGSize(width: images[0].pixelWidth, height: images[0].pixelHeight)
        manager.startCachingImages(for: images, targetSize: size, contentMode: .aspectFit, options: options2)
    }

    func reloadCellsOfInterest(indexPath: IndexPath) {
        var indexes = self.selectedIndexs.map { (value) -> IndexPath in
            return IndexPath(row: value, section: 0)
        }
        if indexes.contains(indexPath) {
            collectionView.reloadItems(at: indexes)
        } else {
            collectionView.reloadItems(at: indexes)
            collectionView.reloadItems(at: [indexPath])
        }
    }

    func style() {
        loadingContainer.layer.cornerRadius = loadingContainer.frame.height / 2
    }
}

extension ChooseImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: cellXibName, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.itemSize = getCellSize()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GalleryImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! GalleryImageCollectionViewCell

        if let image = cachedImages[indexPath.row] {
            cell.imageView.image = image
        } else {
            let tag = indexPath.row
            let asset = images[indexPath.row]
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.deliveryMode = .opportunistic
//            let assetSize = AssetManager.getAssetSizeForCell(asset: asset, cellSize: getCellSize())
            let assetSize = CGSize(width: images[0].pixelWidth, height: images[0].pixelHeight)
            let manager = PHCachingImageManager()
            manager.requestImage(for: asset, targetSize: assetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                if let image = image {
                    cell.imageView.image = image
                    self.cachedImages.updateValue(image, forKey: tag)
                }
            })
//            PHImageManager.default().requestImage(for: asset, targetSize: assetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
//                if let image = image {
//                    cell.imageView.image = image
//                    self.cachedImages.updateValue(image, forKey: tag)
//                }
//            })
        }

        cell.setUp(selectedIndexes: selectedIndexs, indexPath: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexs.contains(indexPath.row) {
            selectedIndexs.remove(at: selectedIndexs.index(of: indexPath.row)!)

        } else {
            selectedIndexs.append(indexPath.row)
        }

        reloadCellsOfInterest(indexPath: indexPath)
    }

    func getCellSize() -> CGSize {
        return CGSize(width: self.view.frame.size.width/3 - 10, height: self.view.frame.size.width/3 - 15)
    }
}
