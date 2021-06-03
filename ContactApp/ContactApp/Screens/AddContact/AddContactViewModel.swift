//
//  AddContactViewModel.swift
//  ContactApp
//
//  Created by Midhunlal M on 16/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

class AddContactViewModel: BaseViewModel {
    private var contact: Contact?
    private var isNewContact: Bool = true
    var contactItemIndex: Int = 0
    
    init(with contact:  Contact?) {
        if let contact = contact {
            self.contact = contact
            isNewContact = false
        }
    }
}

extension AddContactViewModel {
    func getNumberOfContactInfoDetails() -> Int {
        return 4
    }
    
    func getContactInfoDetails(for index: Int) -> (title: String, value: String?, inputType: InputType) {
        switch index {
        case 0:
            return (Constants.firstName, contact?.firstName, .firstName)
        case 1:
            return (Constants.lastName, contact?.lastName, .lastName)
        case 2:
            return (Constants.mobile, contact?.phoneNumber, .phoneNo)
        case 3:
            return (Constants.email, contact?.email, .email)
        default:
            return ("", nil, .default)
        }
    }
    
    func didChangedValue(_ value: String, forType type: InputType) {
        if contact == nil {
            self.contact = Contact()
            self.contact?.favorite = false
        }
        switch type {
        case .firstName:
            contact?.firstName = value
        case .lastName:
            contact?.lastName = value
        case .phoneNo:
            contact?.phoneNumber = value
        case .email:
            contact?.email = value
        default:
            debugPrint("Invalid")
        }
    }
    
    func addOrUpdateContact() {
        if let error = isValidInput() {
            errorHandler?(error)
            return
        }
        if isNewContact {
            addContactDetails()
        } else {
            updateContactDetails()
        }
    }
    
    func getContactAddedMessage() -> String {
        return isNewContact ? AlertMessage.contactAddedSuccess : AlertMessage.contactUpdatedSuccess
    }
    
    private func isValidInput() -> Error? {
        guard let contact = contact else {
            return ErrorUtility.getError(description: AlertMessage.provideContactDetails)
        }
        if let firstName = contact.firstName, firstName.count == 0 {
            return ErrorUtility.getError(description: AlertMessage.provideFirstName)
        }
        if let lastName = contact.lastName, lastName.count == 0 {
            return ErrorUtility.getError(description: AlertMessage.provideLastName)
        }
        if let phoneNumber = contact.phoneNumber, phoneNumber.count == 0 {
            return ErrorUtility.getError(description: AlertMessage.providePhoneNo)
        }
        if let email = contact.email, email.count > 0 {
            if !email.isValidEmail() {
                return ErrorUtility.getError(description: AlertMessage.provideValidEmail)
            }
        } else {
            return ErrorUtility.getError(description: AlertMessage.provideEmail)
        }
        return nil
    }
}

//MARK: - API Calls
extension AddContactViewModel {
    func addContactDetails() {
        guard let contact = contact else { return }
    
        shouldShowLoader = true
        BaseServiceManager.addContact(withDetails: contact) { [weak self] (response, error) in
            self?.shouldShowLoader = false
            if let error = error {
                self?.errorHandler?(error)
                return
            }
            AppDataManager.sharedManager().addNewContact(contact)
            self?.reloadHandler?()
        }
    }
    
    func updateContactDetails() {
        guard let contact = contact else { return }
        
        shouldShowLoader = true
        BaseServiceManager.updateContactDetails(for: contact) { [weak self] (response, error) in
            guard let `self` = self else {return}
            self.shouldShowLoader = false
            if let error = error {
                self.errorHandler?(error)
                return
            }
            AppDataManager.sharedManager().updateContactDetails(forContact: contact, at: self.contactItemIndex)
            self.reloadHandler?()
        }
    }
}
