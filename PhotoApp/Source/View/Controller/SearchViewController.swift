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
    var listViewModel: SearchModelView?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.delegate = self
        
        self.listViewModel = SearchModelView()
        if let viewModel = self.listViewModel {
            viewModel.completionHandler = { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            viewModel.fetchFlickerPhotos()
        }
    }

    
    @IBAction func optionAction(_ sender: Any) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
}

// MARK: UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        self.paging = nil
//        self.loadMore = true
//        guard let searchText = textField.text, searchText.count > 0 else {
//            ImageDownloadManager.shared.cancelAll()
//            self.searches.searchResults.removeAll()
//            self.collectionView?.reloadData()
//            self.loadMore = false
//            return true
//        }
//        searchTextField.startAnimating()
//        self.callSearchApi(searchText: searchText, pageNo: 1)
    
        return true
    }
}
