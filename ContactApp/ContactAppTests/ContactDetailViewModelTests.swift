//
//  ContactDetailViewModelTests.swift
//  ContactAppTests
//
//  Created by Midhunlal M on 16/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import XCTest
@testable import ContactApp

class ContactDetailViewModelTests: XCTestCase {
    var viewModel: ContactDetailViewModel!
    
    override func setUp() {
        super.setUp()
        
        var contact = Contact()
        contact.id = 100
        viewModel = ContactDetailViewModel(with: contact)
        viewModel.viewDidLoad()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testGetNumberOfContactInfoDetails() {
        let rows = viewModel.getNumberOfContactInfoDetails()
        XCTAssertTrue(rows == 2)
    }
    
    func testGetContactInfoDetails() {
        let expectation = XCTestExpectation(description: "expectation")
        viewModel.reloadHandler = { [weak self] in
            guard let `self` = self else { return }
            var details = self.viewModel.getContactInfoDetails(for: 0)
            var isTrue = ( details.title.isEqualTo(Constants.mobile) && details.value?.isEqualTo("+919980123412") ?? false && details.inputType == .phoneNo)
            XCTAssertTrue(isTrue == true)
            
            details = self.viewModel.getContactInfoDetails(for: 1)
            isTrue = ( details.title.isEqualTo(Constants.email) && details.value?.isEqualTo("ab@bachchan.com") ?? false && details.inputType == .email)
            XCTAssertTrue(isTrue == true)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testDidUpdateContactFavouriteStatus() {
        viewModel.contactItemIndex = 0
        viewModel.didUpdateContactFavouriteStatus(false)
        if let contact = AppDataManager.sharedManager().contactList?[viewModel.contactItemIndex] {
            XCTAssertTrue(contact.favorite == false)
        }
        
        viewModel.didUpdateContactFavouriteStatus(true)
        if let contact = AppDataManager.sharedManager().contactList?[viewModel.contactItemIndex] {
            XCTAssertTrue(contact.favorite == true)
        }
    }
    
    func testGetAddContactViewModel() {
        viewModel.contactItemIndex = 0
        let vm = viewModel.getAddContactViewModel()
        XCTAssertTrue(vm.contactItemIndex == 0)
    }
}
