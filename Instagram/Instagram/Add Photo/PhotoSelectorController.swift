//
//  PhotoSelectorController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 6/28/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"

    var images = [UIImage]()
    var selectedImage: UIImage?
    var assets = [PHAsset]()

    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        setupNavigationButtons()
        fetchPhotos()
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    //MARK: - Private methods
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(hanleCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(hanleNextButton))
    }
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        
        let fetchOptions = PHFetchOptions()
        //fetchOptions.fetchLimit = 15
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
        
    fileprivate func fetchPhotos() {

        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        allPhotos.enumerateObjects { (asset, count, stop) in
            
            DispatchQueue.global(qos: .background).async {
                
                let imageManager = PHImageManager.default()
                let targerSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targerSize, contentMode: .aspectFit, options: options) { (image, info) in

                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }

                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Action methods for selectors

    @objc func hanleCancelButton() {
        dismiss(animated: true)
    }

    @objc func hanleNextButton() {
        
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = header?.photoImageView.image
        self.navigationController?.pushViewController(sharePhotoController, animated: true)
        
    }
    //MARK: - Setup collection view
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.row]
        collectionView.reloadData()

        let selectedItem = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedItem, animated: true, scrollPosition: .bottom)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    var header: PhotoSelectorHeader?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        
        self.header = header
        
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
               let selectedAsset = self.assets[index]
               let imageManager = PHImageManager()
               let targetSize = CGSize(width: 600, height: 600)
               imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { (image, info) in
                 
               header.photoImageView.image = image
            }
        }
    }

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //MARK: - Collection view flow layout delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3)/4
        return CGSize(width: width, height: width)
    
    }
}
