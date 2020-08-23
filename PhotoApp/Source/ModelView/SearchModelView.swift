//
//  SearchModelView.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation

class SearchModelView {
    
    // MARK: - Properties Initializer
    var flickerPhotos: [FlickerPhoto]?
    public var completionHandler: ((Bool, Error?) -> (Void))?

    func fetchFlickerPhotos() {
        APIManager.shared.getPhotos { (result) in
            switch result {
            case let  .failure(statusCode, title, subTitle):
                if let completion = self.completionHandler {
                    completion(false,nil)
                }
            case let .success(photo):
                self.flickerPhotos = photo
                if let completion = self.completionHandler {
                    completion(true,nil)
                }
            default:
                if let completion = self.completionHandler {
                    completion(false,nil)
                }
            }
        }
    }
}
