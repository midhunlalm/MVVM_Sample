//
//  AppDataManager.swift
//  ContactApp
//
//  Created by Midhunlal M on 15/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation
import UIKit

final class AppDataManager {
    private static let sharedInstance = AppDataManager()
    private let imageCache = NSCache<AnyObject, AnyObject>()
    var contactList: [Contact]?
    
    private init() { }
    
    // MARK: - Class Methods
    class func sharedManager() -> AppDataManager {
        return sharedInstance
    }
    
    func addImageToCache(_ image: UIImage?, urlString: String) {
        if let image = image {
            imageCache.setObject(image, forKey: urlString as AnyObject)
        }
    }
    
    func getImageFromCache(_ urlString: String) -> UIImage? {
        if let image = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            return image
        }
        return nil
    }
    
    func updateContactDetails(forContact contact: Contact?, at index: Int) {
        guard let contact = contact else { return }
        contactList?[index] = contact
    }
    
    func addNewContact(_ contact: Contact?) {
        guard let contact = contact else { return }
        contactList?.append(contact)
    }
}
