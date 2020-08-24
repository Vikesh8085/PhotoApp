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
    
    func getPhotos(query: String, pageNo: Int, completionHandler: @escaping (NetworkResult) -> Void) {
       
        guard let link = getUrl(query, page: pageNo) else {return}
            
         URLSession.shared.dataTask(with: link) { (data, response, error) in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                let httpStatusCode = HTTPStatusCodes(rawValue: statusCode) {
                switch httpStatusCode {
                case HTTPStatusCodes.success:
                    if let d = data, let obj = try? JSONDecoder().decode(FlickerPhotoDict.self, from: d) {
                        if obj.stat == "ok" {
                            
                            let page = PaginnationHelper(totalPages: obj.photos.pages, total: Int32(obj.photos.total) ?? 0, currentPage: obj.photos.page)
                            completionHandler(NetworkResult.success(obj.photos.photo, page))
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
    
    fileprivate func getUrl(_ query:String, page: Int = 1) -> URL? {
        
        let URLString = "\(APIManagerConstant.baseUrl)/services/rest/?method=flickr.photos.search&api_key=\(APIManagerConstant.key)&text=\(query)&per_page=\(APIManagerConstant.perPageElement)&format=json&nojsoncallback=1&page=\(page)"
        
        guard let url = URL(string:URLString) else {
            return nil
        }
        return url
    }
    
}
