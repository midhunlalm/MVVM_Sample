//
//  StringExtension.swift
//  ContactApp
//
//  Created by Midhunlal M on 13/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

extension String {
    static func getStringOfClass(objectClass: AnyClass) -> String {
        let className = String(describing: objectClass.self)
        return className
    }
    
    func isEqualTo(_ string: String?) -> Bool {
        if let string = string {
            return (self.caseInsensitiveCompare(string) == .orderedSame)
        }
        return false
    }
    
    func isValidEmail() -> Bool {
        let regExp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regExp)
        return predicate.evaluate(with: self)
    }
}
