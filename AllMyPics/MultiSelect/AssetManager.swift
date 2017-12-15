//
//  assetManager.swift
//  imageMultiSelect
//
//  Created by Amir Shayegh on 2017-12-13.
//  Copyright © 2017 Amir Shayegh. All rights reserved.
//

import Foundation
import Photos
import UIKit

class AssetManager {

    static  func getAssetImage(asset: PHAsset, size: CGSize = CGSize.zero, completion: @escaping((UIImage?) -> Void)) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = false

        var assetImage: UIImage!
        var scaleSize = size
        if size == CGSize.zero {
            scaleSize = getAssetSize(asset: asset)
        }

        manager.requestImage(for: asset, targetSize: scaleSize, contentMode: .aspectFill, options: option) { (image, nil) in
            if let image = image {
                completion(image)
            } else {
                manager.requestImageData(for: asset, options: option, resultHandler: { (data, _, orientation, _) in
                    if let data = data {
                        if let image = UIImage.init(data: data) {
                            completion(image)
                        }
                    } else {
                        completion(nil)
                    }
                })
            }
        }
    }

    static func getAssetSize(asset: PHAsset) -> CGSize {
        return CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    }

    static func getAssetSizeForCell(asset: PHAsset, cellSize: CGSize) -> CGSize {
        let assetSize = getAssetSize(asset: asset)

        return assetSize
        let cellW = cellSize.width
        let cellH = cellSize.height

        let assetW = assetSize.width
        let assetH = assetSize.height

        var newW: CGFloat = 0
        var newH: CGFloat = 0

        // if image size is smaller than cell size (very unusual)
        // return the asset size
        if cellH > assetH {
            return assetSize
        }

        // if horizontal
        if assetW > assetH {
            newW = cellW
            newH = newW * assetH / assetW
            print("got \(newH) from \(assetSize.height)")
            return CGSize(width: newW, height: newH)
        // if vertical
        } else {
            newH = cellH
            newW = newH * assetW / assetH
            print("got \(newH) from \(assetSize.height)")
            return CGSize(width: newW, height: newH)
        }
    }
}
