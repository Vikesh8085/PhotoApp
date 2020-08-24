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
    
    //Creates Image view
    lazy var imageView123: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        imgView.contentMode     = .scaleAspectFill
        imgView.clipsToBounds   = true
        imgView.backgroundColor = .clear
        imgView.isHidden        = false
        //           imgView.image = UIImage(named: Constants.placeholder.rawValue)
        return imgView
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUI()
    }
    
    fileprivate func setUI() {
        self.contentView.addSubview(imageView123)
    }
}
