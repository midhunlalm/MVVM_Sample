//
//  UITableViewExtension.swift
//  ContactApp
//
//  Created by Midhunlal M on 13/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNib(_ className: AnyClass) {
        let classNameString = String.getStringOfClass(objectClass: className)
        register(UINib.init(nibName: classNameString, bundle: .main), forCellReuseIdentifier: classNameString)
    }
    
    func registerHeaderFooterNib(_ className: AnyClass) {
        let classNameString = String.getStringOfClass(objectClass: className)
        register(UINib.init(nibName: classNameString, bundle: .main),
                 forHeaderFooterViewReuseIdentifier: classNameString)
    }
    
    func registerHeaderFooterClass(_ className: AnyClass) {
        let classNameString = String.getStringOfClass(objectClass: className)
        register(className, forHeaderFooterViewReuseIdentifier: classNameString)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ className: T.Type,
                                                 indexPath: IndexPath) -> T {
        let className = String.getStringOfClass(objectClass: className)
        return self.dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ className: T.Type,
                                                 identifier: String,
                                                 indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}
