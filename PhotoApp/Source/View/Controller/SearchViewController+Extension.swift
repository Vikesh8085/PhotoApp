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
        self.selectedIndexPath = indexPath
        let cell = collectionView.cellForItem(at: indexPath)
        let nav = self.navigationController
        guard let model = self.listViewModel?.flickerPhotos?[indexPath.row] else { return }
        
        let vc = DetailViewController.instantiate()
        nav?.delegate = vc.transitionController
        vc.transitionController.fromDelegate = self
        vc.transitionController.toDelegate = vc
        vc.photos = (cell as! PhotoCell).imageView.image
        nav?.pushViewController(vc, animated: true)
    }
    
    
}


extension SearchViewController: ZoomAnimatorDelegate {
    
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
        
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        let cell = self.collectionView.cellForItem(at: self.selectedIndexPath) as! PhotoCell
        
        let cellFrame = self.collectionView.convert(cell.frame, to: self.view)
        
        if cellFrame.minY < self.collectionView.contentInset.top {
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .top, animated: false)
        } else if cellFrame.maxY > self.view.frame.height - self.collectionView.contentInset.bottom {
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .bottom, animated: false)
        }
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        
        //Get a guarded reference to the cell's UIImageView
        let referenceImageView = getImageViewFromCollectionViewCell(for: self.selectedIndexPath)
        
        return referenceImageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        
        self.view.layoutIfNeeded()
        self.collectionView.layoutIfNeeded()
        
        //Get a guarded reference to the cell's frame
        let unconvertedFrame = getFrameFromCollectionViewCell(for: self.selectedIndexPath)

        let cellFrame = self.collectionView.convert(unconvertedFrame, to: self.view)

        if cellFrame.minY < self.collectionView.contentInset.top {
            return CGRect(x: cellFrame.minX, y: self.collectionView.contentInset.top, width: cellFrame.width, height: cellFrame.height - (self.collectionView.contentInset.top - cellFrame.minY))
        }
        
        return unconvertedFrame
    }
    
}

extension SearchViewController {
    
    //This function prevents the collectionView from accessing a deallocated cell. In the event
    //that the cell for the selectedIndexPath is nil, a default UIImageView is returned in its place
    func getImageViewFromCollectionViewCell(for selectedIndexPath: IndexPath) -> UIImageView {
        
        //Get the array of visible cells in the collectionView
        let visibleCells = self.collectionView.indexPathsForVisibleItems
        
        //If the current indexPath is not visible in the collectionView,
        //scroll the collectionView to the cell to prevent it from returning a nil value
        if !visibleCells.contains(self.selectedIndexPath) {
            
            //Scroll the collectionView to the current selectedIndexPath which is offscreen
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
            
            //Reload the items at the newly visible indexPaths
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()
            
            //Guard against nil values
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell) else {
                //Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            //The PhotoCollectionViewCell was found in the collectionView, return the image
            return guardedCell.imageView
        }
        else {
            
            //Guard against nil return values
            guard let guardedCell = self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell else {
                //Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            //The PhotoCollectionViewCell was found in the collectionView, return the image
            return guardedCell.imageView
        }
        
    }
    
    //This function prevents the collectionView from accessing a deallocated cell. In the
      //event that the cell for the selectedIndexPath is nil, a default CGRect is returned in its place
      func getFrameFromCollectionViewCell(for selectedIndexPath: IndexPath) -> CGRect {
          
          //Get the currently visible cells from the collectionView
          let visibleCells = self.collectionView.indexPathsForVisibleItems
          
          //If the current indexPath is not visible in the collectionView,
          //scroll the collectionView to the cell to prevent it from returning a nil value
          if !visibleCells.contains(self.selectedIndexPath) {
              
              //Scroll the collectionView to the cell that is currently offscreen
              self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
              
              //Reload the items at the newly visible indexPaths
              self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
              self.collectionView.layoutIfNeeded()
              
              //Prevent the collectionView from returning a nil value
              guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell) else {
                  return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
              }
              
              return guardedCell.frame
          }
          //Otherwise the cell should be visible
          else {
              //Prevent the collectionView from returning a nil value
              guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCell) else {
                  return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
              }
              //The cell was found successfully
              return guardedCell.frame
          }
      }
    
}
