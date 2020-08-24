//
//  SearchModelView.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation
import UIKit

class SearchModelView {
    
    var paging : PaginnationHelper?
    var isLoadMore: Bool = false
    
    // MARK: - Properties Initializer
    var flickerPhotos: [FlickerPhoto]?
    public var completionHandler: ((Bool, Error?) -> (Void))?
    var searchViewController: SearchViewController?

    init(searchViewController: SearchViewController) {
        self.searchViewController = searchViewController
    }
    
    func fetchFlickerPhotos(query: String, pageNo: Int) {
        
        if ReachabilityWrapper.shared.isNetworkAvailable() {
            self.searchViewController?.view.showIndicator()
            APIManager.shared.getPhotos(query: query, pageNo: pageNo) { (result) in
                switch result {
                case let  .failure(_, title, subTitle):
                    if let completion = self.completionHandler {
                        completion(false,nil)
                        DispatchQueue.main.async {
                            self.showError(title: title, message: subTitle)
                        }
                    }
                case let .success(photo, page):
                    self.handleData(data: photo,paging: page)
                }
                DispatchQueue.main.async {
                    self.searchViewController?.view.hideIndicator()
                }
            }
        } else {
            self.searchViewController?.showAlert(title: InternetAvailability.title.rawValue, message: InternetAvailability.message.rawValue, preferredStyle: .alert, alertActions: [(AlertAction.retryAction.rawValue, .default)]) { (index) in
                if index == 0 {
                    self.fetchFlickerPhotos(query: query, pageNo: pageNo)
                }
            }
        }
    }
    
    private func showError(title:String, message: String) {
        self.searchViewController?.showAlert(title: title, message: message, preferredStyle: .alert, alertActions: [(AlertAction.retryAction.rawValue, .default)]) { (index) in
        }
    }
    
    private func handleData(data: [FlickerPhoto], paging: PaginnationHelper) {
        
        if paging.currentPage == 1 {
            ImageDownloadManager.shared.cancelPrevivousOperation()
            self.flickerPhotos?.removeAll()
        }
        
        self.paging = paging
        paging.currentPage == 1 ? self.flickerPhotos = data : self.flickerPhotos?.append(contentsOf: data)
        if let completion = self.completionHandler {
            completion(true,nil)
        }
        self.isLoadMore = false
    }
}
