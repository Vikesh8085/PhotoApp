//
//  PhotoCell.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 23/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUI()
    }
    
    fileprivate func setUI() {
        
    }
}
