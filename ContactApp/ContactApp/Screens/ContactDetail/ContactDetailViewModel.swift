//
//  ContactDetailViewModel.swift
//  ContactApp
//
//  Created by Midhunlal M on 15/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

class ContactDetailViewModel: BaseViewModel {
    private var contact: Contact?
    var contactItemIndex: Int = 0
    
    init(with contact:  Contact) {
        self.contact = contact
    }
    
    func viewDidLoad() {
        fetchContactDetails()
    }
}

extension ContactDetailViewModel {
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
    
    var contactPhoneNumber: String? {
        return contact?.phoneNumber
    }
    
    var contactEmail: String? {
        return contact?.email
    }
    
    var profilePicUrl: String? {
        if let profilePic = contact?.profilePic {
            return NetworkConstants.baseUrl + profilePic
        }
        return nil
    }
    
    var isFavorite: Bool {
        if let favorite = contact?.favorite {
            return favorite
        }
        return false
    }
    
    func getNumberOfContactInfoDetails() -> Int {
        return 2
    }
    
    func getContactInfoDetails(for index: Int) -> (title: String, value: String?, inputType: InputType) {
        if index == 0 {
            return (Constants.mobile, contact?.phoneNumber, .phoneNo)
        } else {
            return (Constants.email, contact?.email, .email)
        }
    }
    
    func didUpdateContactFavouriteStatus(_ isFavorite: Bool) {
        contact?.favorite = isFavorite
        AppDataManager.sharedManager().updateContactDetails(forContact: contact, at: contactItemIndex)
        updateContactFavouriteStatus()
    }
    
    func getAddContactViewModel() -> AddContactViewModel {
        let viewModel = AddContactViewModel(with: contact)
        viewModel.contactItemIndex = contactItemIndex
        return viewModel
    }
}

//MARK: - API Calls
private extension ContactDetailViewModel {
    func fetchContactDetails() {
        guard let contactId = contact?.id else { return }
        
        shouldShowLoader = true
        BaseServiceManager.fetchContactDetails(for: contactId) { [weak self] (response, error) in
            self?.shouldShowLoader = false
            if let error = error {
                self?.errorHandler?(error)
                return
            }
            if let contact = response as? Contact {
                self?.contact = contact
                self?.reloadHandler?()
            }
        }
    }
    
    func updateContactFavouriteStatus() {
        guard let contact = contact else { return }
        shouldShowLoader = true
        BaseServiceManager.updateContactDetails(for: contact) { [weak self] (response, error) in
            self?.shouldShowLoader = false
        }
    }
}
