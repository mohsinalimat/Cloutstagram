//
//  PhotoSelectorController.swift
//  Cloutstagram
//
//  Created by sana on 2017-10-03.
//  Copyright © 2017 sanaknaki. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // ID's
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .yellow
        
        setupNavigationButtons()
        
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        
        // Chosen picture header
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        fetchPhotos()
    }
    
    var selectedImage: UIImage?
    
    // Select a photo from the grid
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Selected image
        self.selectedImage = images[indexPath.item]
        
        self.collectionView?.reloadData()
    }
    
    // Array of images
    var images = [UIImage]()
    
    // Fetch photos to load
    fileprivate func fetchPhotos(){
        
        // How we going to fetch pictures
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 15
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor] // Display most recent pictures in the grid first
        
        // Fetch all photos from lib
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        // A for loop for all fetched photos
        allPhotos.enumerateObjects({ (asset, count, stop) in
            
            // Sizing out the picture to properly fit
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 350, height: 350)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                
                // Push image to image array
                if let image = image {
                    self.images.append(image)
                    
                    if self.selectedImage == nil {
                        self.selectedImage = image
                    }
                }
                
                // Call when you done fetching all photos
                if count == allPhotos.count - 1 {
                    self.collectionView?.reloadData()
                }
            })
            
        })
    }
    
    // Allow a line underneath the chosen header picture
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    // Chosen picture size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = view.frame.width
        
        return CGSize(width: width, height: width)
    }
    
    // Override header function
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        
        // Turn header to chosen picture
        header.photoImageView.image = selectedImage
        
        return header
    }
    
    // Size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3) / 4
        
        return CGSize(width: width, height: width)
    }
    
    // Spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // NumOf
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // Return the cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        
        cell.photoImageView.image = images[indexPath.item]
        
        return cell
    }
    
    // Remove status bar info
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Navigation items
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    // What happens when you click cancel
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // What happens when you click next
    @objc func handleNext() {
        print("Handling Next")
    }
    
}
