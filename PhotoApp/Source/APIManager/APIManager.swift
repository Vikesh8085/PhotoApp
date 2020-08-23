//
//  APIManager.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 23/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//
import Foundation

final class APIManager {

    static let shared = APIManager()
    
    let urlEndPoint = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=de24642a8668fb0318ec5b9cecfda18c&text=apple&per_page=20&format=json&nojsoncallback=1&page=1"
   
    
    func getPhotos(completionHandler: @escaping (NetworkResult) -> Void) {
       
         URLSession.shared.dataTask(with: URL(string: urlEndPoint)!) { (data, response, error) in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                let httpStatusCode = HTTPStatusCodes(rawValue: statusCode) {
                switch httpStatusCode {
                case HTTPStatusCodes.success:
                    if let d = data, let obj = try? JSONDecoder().decode(FlickerPhotoDict.self, from: d) {
                        if obj.stat == "ok" {
                            completionHandler(NetworkResult.success(obj.photos.photo))
                        }
                    }
                case HTTPStatusCodes.tooManyRequests:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.tooManyRequests, title: "429", subTitle: "Too many requests"))
                case HTTPStatusCodes.notFound:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.notFound, title: "404", subTitle: "Not Found"))
                case HTTPStatusCodes.unAvailable:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.unAvailable, title: "503", subTitle: "Un Available"))
                }
            }
        }.resume()
    }
    
    
}
