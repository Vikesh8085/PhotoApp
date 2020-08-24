//
//  SearchViewController.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 23/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit

class SearchViewController: UICollectionViewController {
    
    @IBOutlet weak var searchField: UITextField!
    var footerView:CustomFooterView?
    let footerViewReuseIdentifier = "RefreshFooterView"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var photoPerRow: CGFloat = 3

    var listViewModel: SearchModelView?
    var selectedIndexPath: IndexPath!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageUI()
    }
    
    private func manageUI() {
        searchField.delegate = self
        collectionView?.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)

    }
    
    private func fetchData(query: String, pageNo: Int) {
        self.listViewModel = SearchModelView(searchViewController: self)
        if let viewModel = self.listViewModel {
            viewModel.completionHandler = { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            viewModel.fetchFlickerPhotos(query: query, pageNo: pageNo)
        }
    }
    
    @IBAction func optionAction(_ sender: Any) {
        self.searchField.resignFirstResponder()
        self.showOptions()
    }
    
    func showOptions () {
        
        self.showAlert(title: "PhotoApp", message: "Images per row", preferredStyle: .actionSheet, alertActions: [ (AlertAction.item2.rawValue, .default),(AlertAction.item3.rawValue, .default),(AlertAction.item4.rawValue, .default),(AlertAction.cancelAction.rawValue, .destructive)]) { (index) in
            if index <= 2 {
                self.photoPerRow = CGFloat(index) + 2.0
                self.collectionView?.reloadData()
            }
        }
    }
    
    func loadMore() {
        guard let query = self.searchField.text, !query.isEmpty else {
            return
        }
        
        if !(self.listViewModel?.isLoadMore ?? false) && listViewModel?.paging!.currentPage! ?? 0 < listViewModel?.paging!.totalPage! ?? 0 {
            self.listViewModel?.isLoadMore = true
            self.fetchData(query: query, pageNo: (listViewModel?.paging!.currentPage! ?? 0) + 1)
        }
    }
}

// MARK: UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.listViewModel?.paging = nil
        self.listViewModel?.isLoadMore = true
        
        guard let query = textField.text, !query.isEmpty else {
            ImageDownloadManager.shared.cancelPrevivousOperation()
            self.listViewModel?.flickerPhotos?.removeAll()
            self.collectionView?.reloadData()
            self.listViewModel?.isLoadMore = false
            return true
        }
        self.fetchData(query: query, pageNo: 1)
        return true
    }
}
