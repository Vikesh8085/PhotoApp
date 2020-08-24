//
//  DetailViewController.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 23/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,Storyboarded {

    @IBOutlet weak var imageView: UIImageView!
    var photos: UIImage?
    var transitionController = ZoomTransitionController()
    weak var fromDelegate: ZoomAnimatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = photos
    }
}

extension DetailViewController: ZoomAnimatorDelegate {
 
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        return self.imageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        return self.view.convert(self.imageView.frame, to: self.view)
    }
}
