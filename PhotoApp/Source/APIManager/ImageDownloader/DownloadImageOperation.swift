//
//  DownloadImageOperation.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation
import UIKit

class DownloadImageOperation : CustomOperation {
    
   var downloadHandler: ImageDownloadHandler?
    var imageUrl: URL!
    private var indexPath: IndexPath?
       
    required init (url: URL, indexPath: IndexPath?) {
        self.imageUrl = url
        self.indexPath = indexPath
    }
     
    override func main() {
          fetchList()
    }
    private func fetchList() {
        
        let newSession = URLSession.shared
        let downloadTask = newSession.downloadTask(with: self.imageUrl) { (location, response, error) in
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                let image = UIImage(data: data)
                self.downloadHandler?(image,self.imageUrl, self.indexPath,error)
            }
            super.finish()
        }
        downloadTask.resume()
    }
}
