//
//  UIImageViewExtension.swift
//  ContactApp
//
//  Created by Midhunlal M on 15/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageFromUrlString(_ urlString: String?) {
        if let urlString = urlString {
            if let image = AppDataManager.sharedManager().getImageFromCache(urlString) {
                self.image = image
            } else {
                setImageFrom(urlString: urlString)
            }
        }
    }
}

private extension UIImageView {
    func setImageFrom(urlString: String) {
        if let url = URL(string: urlString) {
            viewWithTag(564)?.removeFromSuperview()
            let frameSize = self.frame.size
            
            let activityIndicatorView = UIActivityIndicatorView(style: .medium)
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.center = CGPoint(x: frameSize.width * 0.5, y: frameSize.height * 0.5)
            activityIndicatorView.startAnimating()
            activityIndicatorView.tag = 564
            addSubview(activityIndicatorView)
            
            ApiServiceManager.sharedInstance.executeImageDownload(url) { [weak self] (image) in
                DispatchQueue.main.async {
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.removeFromSuperview()
                    self?.image = image
                    AppDataManager.sharedManager().addImageToCache(image, urlString: urlString)
                }
            }
        }
    }
}

