//
//  UIViewExtension.swift
//  ContactApp
//
//  Created by Midhunlal M on 15/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

extension UIView {
    func setGradientBackground(startColor: UIColor?, endColor: UIColor?) {
        guard let colorTop = startColor?.cgColor, let colorBottom = endColor?.cgColor else { return }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds

        self.layer.insertSublayer(gradientLayer, at:0)
    }
}
