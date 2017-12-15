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

    let cellReuseIdentifier = "GalleryImageCell"
    let cellXibName = "GalleryImageCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        lockdown()
        style()
        loadData()
        setUpCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(sent), name: .selectedImages, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

    @objc func sent() {}

    @objc func appWillEnterForeground() {
        if self.images.count != AssetManager.sharedInstance.getPHAssetImages().count {
            reloadData()
        }
    }

    @IBAction func addImages(_ sender: Any) {
        if selectedIndexs.count == 0 {
            closeVC()
        }
        lockdown()
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

    func lockdown() {
        self.loading.startAnimating()
        self.addButton.isUserInteractionEnabled = false
        self.cancelButton.isUserInteractionEnabled = false
        self.loading.isHidden = false
        self.loadingContainer.isHidden = false
        self.collectionView.isUserInteractionEnabled = false
    }

    func unlock() {
        self.loading.stopAnimating()
        self.addButton.isUserInteractionEnabled = true
        self.cancelButton.isUserInteractionEnabled = true
        self.loading.isHidden = true
        self.loadingContainer.isHidden = true
        self.collectionView.isUserInteractionEnabled = true
    }

    func reloadCellsOfInterest(indexPath: IndexPath) {
        let indexes = self.selectedIndexs.map { (value) -> IndexPath in
            return IndexPath(row: value, section: 0)
        }
        if indexes.contains(indexPath) {
            self.collectionView.reloadItems(at: indexes)
        } else {
            self.collectionView.reloadItems(at: indexes)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }

    func style() {
        loadingContainer.layer.cornerRadius = loadingContainer.frame.height / 2
    }
}

extension ChooseImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func reloadData() {
        self.selectedIndexs.removeAll()
        loadData()
    }
    func loadData() {
        self.images = AssetManager.sharedInstance.getPHAssetImages()
        self.collectionView.reloadData()
    }

    func setUpCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(UINib(nibName: cellXibName, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)

        // set size of cells
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.itemSize = getCellSize()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GalleryImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! GalleryImageCollectionViewCell

        cell.setUp(selectedIndexes: selectedIndexs, indexPath: indexPath, phAsset: images[indexPath.row])

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
