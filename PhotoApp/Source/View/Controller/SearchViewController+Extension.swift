//
//  SearchViewController+Extension.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController {
        
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listViewModel?.flickerPhotos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        return cell
    }

    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let model = self.listViewModel?.flickerPhotos?[indexPath.row] else { return }

        (cell as! PhotoCell).imageView.image = #imageLiteral(resourceName: "placeholder")
        ImageDownloadManager.shared.downloadPhoto(model, indexPath: indexPath) { (image, url, indexPathh, error) in
            if let indexPathNew = indexPathh {
                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: indexPathNew) as? PhotoCell {
                        cell.imageView.image = image
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let model = self.listViewModel?.flickerPhotos?[indexPath.row] else { return }
        let vc = DetailViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
