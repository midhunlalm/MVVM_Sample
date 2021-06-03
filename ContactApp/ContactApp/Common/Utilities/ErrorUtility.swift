//
//  ErrorUtility.swift
//  ContactApp
//
//  Created by Midhunlal M on 16/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

class ErrorUtility {
    static func getError(with statusCode: Int = 999, description: String) -> Error {
        let userInfo =  [NSLocalizedDescriptionKey: description]
        return NSError(domain: "", code: statusCode, userInfo: userInfo)
    }
}
