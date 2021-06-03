//
//  ContactCellViewModel.swift
//  ContactApp
//
//  Created by Midhunlal M on 14/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

class ContactCellViewModel {
    private var contact: Contact?
    
    init(with contact:  Contact) {
        self.contact = contact
    }
    
    var profilePicUrl: String? {
        if let profilePic = contact?.profilePic {
            return NetworkConstants.baseUrl + profilePic
        }
        return nil
    }
    
    var contactName: String {
        var text: String = ""
        if let firstName = contact?.firstName {
            text = firstName + " "
        }
        if let lastName = contact?.lastName {
            text += lastName
        }
        return text
    }
    
    var isFavorite: Bool {
        if let favorite = contact?.favorite {
            return favorite
        }
        return false
    }
}
