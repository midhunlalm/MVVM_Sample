//
//  ContactListViewModelTests.swift
//  ContactAppTests
//
//  Created by Midhunlal M on 16/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import XCTest
@testable import ContactApp

class ContactListViewModelTests: XCTestCase {
    var viewModel: ContactListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ContactListViewModel()
        viewModel.viewDidLoad()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testGetNumberOfRows() {
        let expectation = XCTestExpectation(description: "expectation")
        viewModel.reloadHandler = { [weak self] in
            guard let `self` = self else { return }
            let rows = self.viewModel.getNumberOfRows()
            XCTAssertTrue(rows == 2)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetCellViewModel() {
        let expectation = XCTestExpectation(description: "expectation")
        viewModel.reloadHandler = { [weak self] in
            guard let `self` = self else { return }
            var vm = self.viewModel.getCellViewModel(for: 0)
            XCTAssertTrue(vm != nil)
            
            vm = self.viewModel.getCellViewModel(for: 2)
            XCTAssertTrue(vm == nil)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetContactDetailViewModel() {
        let expectation = XCTestExpectation(description: "expectation")
        viewModel.reloadHandler = { [weak self] in
            guard let `self` = self else { return }
            var vm = self.viewModel.getContactDetailViewModel(for: 0)
            XCTAssertTrue(vm != nil)
            
            vm = self.viewModel.getContactDetailViewModel(for: 2)
            XCTAssertTrue(vm == nil)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
