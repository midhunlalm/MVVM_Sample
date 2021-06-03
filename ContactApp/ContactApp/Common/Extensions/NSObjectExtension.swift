//
//  NSObjectExtension.swift
//  ContactApp
//
//  Created by Midhunlal M on 13/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

extension NSObject {
    /**
     @abstract Variable to get class name
     */
    var className: String {
        return String(describing: type(of: self))
    }
    /**
     @abstract Class variable to get class name
     */
    class var className: String {
        return String(describing: self)
    }
}
