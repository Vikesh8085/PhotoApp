//
//  PhotoModel.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 23/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation

struct FlickerPhotoDict : Decodable {
    let stat: String
    let photos:Photos
}

struct Photos : Decodable {
    let page : Int
    let pages : Int
    let perpage : Int
    let total : String
    let photo: [FlickerPhoto]
}

struct FlickerPhoto : Decodable {
    let id : String
    let owner : String
    let secret : String
    let server : String
    let farm : Int
    let title : String
    let ispublic : Int
    let isfriend : Int
    let isfamily : Int
    
    func flickrImageURL(_ size:String = "m") -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size).jpg") {
            return url
        }
        return nil
    }
}
