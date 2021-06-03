//
//  ContactListController.swift
//  ContactApp
//
//  Created by Midhunlal M on 13/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

class ContactListController: BaseController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ContactListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupProperties()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
    }
    
    //MARK: - Button Actions
    @objc func didClickedGroupButton() {
    }
    
    @objc func didClickedPlusButton() {
        let addContactVC = Storyboard.main.instantiateVC(AddContactController.self)
        addContactVC.viewModel = viewModel.getAddContactViewModel()
        navigationController?.pushViewController(addContactVC, animated: true)
    }
}

//MARK: - Helper Methods
private extension ContactListController {
    func setupInterface() {
        setupNavigationBar()
        screenTitle = ScreenTitle.contacts
    }
    
    func setupNavigationBar() {
        let groupButton = UIBarButtonItem(title: Constants.group, style: .plain, target: self, action: #selector(didClickedGroupButton))
        navigationItem.leftBarButtonItem = groupButton
        
        let plusButton = UIBarButtonItem(image: AppIcon.plus, style: .plain, target: self, action: #selector(didClickedPlusButton))
        navigationItem.rightBarButtonItem = plusButton
    }
    
    func setupProperties() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        
        tableView.registerNib(ContactCell.self)
    }
    
    func setupBindings() {
        viewModel.reloadHandler = { [weak self] in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }
        viewModel.errorHandler = { [weak self] (error) in
            self?.showAlert(error: error)
        }
        viewModel?.loaderHandler = { [weak self] (shouldShow) in
            if let shouldShow = shouldShow, shouldShow == true {
                self?.showLoader(inView: self?.view)
            } else {
                self?.hideLoader()
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension ContactListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ContactCell.self, indexPath: indexPath)
        cell.configure(with: viewModel.getCellViewModel(for: indexPath.row))
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ContactListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactDetailVC = Storyboard.main.instantiateVC(ContactDetailController.self)
        contactDetailVC.viewModel = viewModel.getContactDetailViewModel(for: indexPath.row)
        navigationController?.pushViewController(contactDetailVC, animated: true)
    }
}
