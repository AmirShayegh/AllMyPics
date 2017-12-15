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

    static let sharedInstance = AssetManager()

    let phManager: PHCachingImageManager?

    private init() {
        phManager = PHCachingImageManager()
    }

    func getThumbnailSize() -> CGSize {
        return CGSize(width: 150, height: 150)
    }

    func getPHImageRequestOptions() -> PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        return options
    }

    func getPHAssetImages() -> [PHAsset] {
        var phCache = [PHAsset]()
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        let phassets = PHAsset.fetchAssets(with: .image, options: options)
        phassets.enumerateObjects { (asset, count, stop) in
            phCache.append(asset)
            if phCache.count == phassets.count {
                phCache.reverse()
            }
        }
        return phCache
    }

    func cacheImages() {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        phManager?.startCachingImages(for: getPHAssetImages(), targetSize: getThumbnailSize(), contentMode: .aspectFit, options: options)
    }
}
