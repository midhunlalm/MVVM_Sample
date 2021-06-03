//
//  ContactListViewModel.swift
//  ContactApp
//
//  Created by Midhunlal M on 13/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

class ContactListViewModel: BaseViewModel {
    private var contactListViewModel: [ContactCellViewModel]?
    
    func viewDidLoad() {
        fetchContactList()
    }
    
    func refreshData() {
        guard let contactList = AppDataManager.sharedManager().contactList else { return }
        contactListViewModel = contactList.map({ContactCellViewModel(with: $0)})
        reloadHandler?()
    }
}

extension ContactListViewModel {
    func getNumberOfRows() -> Int {
        return contactListViewModel?.count ?? 0
    }
    
    func getCellViewModel(for index: Int)  -> ContactCellViewModel? {
        if let contactListViewModel = contactListViewModel, contactListViewModel.count > index {
            return contactListViewModel[index]
        }
        return nil
    }
    
    func getContactDetailViewModel(for index: Int)  -> ContactDetailViewModel? {
        if let contactList = AppDataManager.sharedManager().contactList, contactList.count > index {
            let viewModel = ContactDetailViewModel(with: contactList[index])
            viewModel.contactItemIndex = index
            return viewModel
        }
        return nil
    }
    
    func getAddContactViewModel() -> AddContactViewModel {
        return AddContactViewModel(with: nil)
    }
}

//MARK: - API Calls
private extension ContactListViewModel {
    func fetchContactList() {
        shouldShowLoader = true
        BaseServiceManager.fetchContactList { [weak self] (response, error) in
            self?.shouldShowLoader = false
            if let error = error {
                self?.errorHandler?(error)
                return
            }
            if let contacts = response as? [Contact] {
                AppDataManager.sharedManager().contactList = contacts
                self?.refreshData()
            }
        }
    }
}
