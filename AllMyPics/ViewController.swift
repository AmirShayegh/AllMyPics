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
    lazy var galleryVC: ChooseImageViewController = {
        let storyboard = UIStoryboard(name: "ChooseImage", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: "ChooseImage") as! ChooseImageViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .selectedImages, object: nil, queue: nil, using:catchSelectedImages)
    }

    func catchSelectedImages(notification:Notification) -> Void {
        let phAssets: [PHAsset] = (notification.userInfo!["name"] as! [PHAsset])
        print("got back \(phAssets.count) images")
    }
    
    @IBAction func goToChoose(_ sender: Any) {
        self.present(galleryVC, animated: true, completion: nil)
    }

}

