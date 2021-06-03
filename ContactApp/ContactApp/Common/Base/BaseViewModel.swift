//
//  BaseViewModel.swift
//  ContactApp
//
//  Created by Midhunlal M on 13/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

class BaseViewModel {
    var reloadHandler: (()-> Void)?
    var errorHandler: ((Error?)-> Void)?
    var loaderHandler: ((Bool?)-> Void)?
    var shouldShowLoader = false {
        didSet {
            self.loaderHandler?(shouldShowLoader)
        }
    }
}
