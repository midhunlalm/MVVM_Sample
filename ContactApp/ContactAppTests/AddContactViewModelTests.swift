//
//  AddContactViewModelTests.swift
//  ContactAppTests
//
//  Created by Midhunlal M on 16/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import XCTest
@testable import ContactApp

class AddContactViewModelTests: XCTestCase {
    var viewModel: AddContactViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AddContactViewModel(with: nil)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testGetNumberOfContactInfoDetails() {
        let rows = viewModel.getNumberOfContactInfoDetails()
        XCTAssertTrue(rows == 4)
    }
    
    func testGetContactInfoDetails() {
        var details = self.viewModel.getContactInfoDetails(for: 0)
        var isTrue = ( details.title.isEqualTo(Constants.firstName) && details.value == nil && details.inputType == .firstName)
        XCTAssertTrue(isTrue == true)
        
        details = self.viewModel.getContactInfoDetails(for: 1)
        isTrue = ( details.title.isEqualTo(Constants.lastName) && details.value == nil && details.inputType == .lastName)
        XCTAssertTrue(isTrue == true)
        
        details = self.viewModel.getContactInfoDetails(for: 2)
        isTrue = ( details.title.isEqualTo(Constants.mobile) && details.value == nil && details.inputType == .phoneNo)
        XCTAssertTrue(isTrue == true)
        
        details = self.viewModel.getContactInfoDetails(for: 3)
        isTrue = ( details.title.isEqualTo(Constants.email) && details.value == nil && details.inputType == .email)
        XCTAssertTrue(isTrue == true)
        
        var contact = Contact()
        contact.id = 100
        contact.firstName = "Abc"
        contact.lastName = "Efg"
        contact.phoneNumber = "1234567891"
        contact.email = "a@a.aaa"
        viewModel = AddContactViewModel(with: contact)
        
        details = self.viewModel.getContactInfoDetails(for: 0)
        isTrue = ( details.title.isEqualTo(Constants.firstName) && details.value != nil && details.inputType == .firstName)
        XCTAssertTrue(isTrue == true)
        
        details = self.viewModel.getContactInfoDetails(for: 1)
        isTrue = ( details.title.isEqualTo(Constants.lastName) && details.value != nil && details.inputType == .lastName)
        XCTAssertTrue(isTrue == true)
        
        details = self.viewModel.getContactInfoDetails(for: 2)
        isTrue = ( details.title.isEqualTo(Constants.mobile) && details.value != nil && details.inputType == .phoneNo)
        XCTAssertTrue(isTrue == true)
        
        details = self.viewModel.getContactInfoDetails(for: 3)
        isTrue = ( details.title.isEqualTo(Constants.email) && details.value != nil && details.inputType == .email)
        XCTAssertTrue(isTrue == true)
    }
    
    func testDidChangedValue() {
        viewModel.didChangedValue("aaa", forType: .firstName)
        var details = self.viewModel.getContactInfoDetails(for: 0)
        var isTrue = ( details.title.isEqualTo(Constants.firstName) && details.value?.isEqualTo("aaa") ?? false)
        XCTAssertTrue(isTrue == true)
        
        viewModel.didChangedValue("bbb", forType: .lastName)
        details = self.viewModel.getContactInfoDetails(for: 1)
        isTrue = ( details.title.isEqualTo(Constants.lastName) && details.value?.isEqualTo("bbb") ?? false)
        XCTAssertTrue(isTrue == true)
        
        viewModel.didChangedValue("123", forType: .phoneNo)
        details = self.viewModel.getContactInfoDetails(for: 2)
        isTrue = ( details.title.isEqualTo(Constants.mobile) && details.value?.isEqualTo("123") ?? false)
        XCTAssertTrue(isTrue == true)
        
        viewModel.didChangedValue("a@a.aaa", forType: .email)
        details = self.viewModel.getContactInfoDetails(for: 3)
        isTrue = ( details.title.isEqualTo(Constants.email) && details.value?.isEqualTo("a@a.aaa") ?? false)
        XCTAssertTrue(isTrue == true)
    }
    
    func testAddOrUpdateContact() {
        viewModel = AddContactViewModel(with: nil)
        viewModel.errorHandler = { (error) in
            XCTAssertTrue(error != nil)
        }
        viewModel.addOrUpdateContact()
        
        var contact = Contact()
        contact.id = 100
        contact.firstName = "Abc"
        contact.lastName = "Efg"
        contact.phoneNumber = "1234567891"
        contact.email = "a@a.aaa"
        viewModel = AddContactViewModel(with: contact)
        
        viewModel.errorHandler = { (error) in
            XCTAssertTrue(error == nil)
        }
        viewModel.addOrUpdateContact()
        
        let expectation = XCTestExpectation(description: "expectation")
        viewModel.reloadHandler = {
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetContactAddedMessage() {
        viewModel = AddContactViewModel(with: nil)
        var isTrue = viewModel.getContactAddedMessage().isEqualTo(AlertMessage.contactAddedSuccess)
        XCTAssertTrue(isTrue == true)
        
        let contact = Contact()
        viewModel = AddContactViewModel(with: contact)
        
        isTrue = viewModel.getContactAddedMessage().isEqualTo(AlertMessage.contactUpdatedSuccess)
        XCTAssertTrue(isTrue == true)
    }
}
