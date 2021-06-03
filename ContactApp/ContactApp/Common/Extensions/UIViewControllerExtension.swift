//
//  UIViewControllerExtension.swift
//  ContactApp
//
//  Created by Midhunlal M on 16/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     @abstract Method add child view controller in a specific view
     */
    func addChildVC(viewController: UIViewController, in containerView: UIView) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
}
