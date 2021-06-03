//
//  AddContactController.swift
//  ContactApp
//
//  Created by Midhunlal M on 16/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

class AddContactController: BaseController {
    @IBOutlet weak var contactNameContainerView: UIView!
    @IBOutlet weak var contactInfoContainerView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    private var imagePicker: ImagePicker?
    
    var viewModel: AddContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupProperties()
        setupBindings()
    }
    
    //MARK: - Button Actions
    @IBAction func didClickedCameraButton(_ sender: Any) {
        imagePicker?.present(from: view)
    }
    
    @objc func didClickedCancelButton() {
        popViewController()
    }
    
    @objc func didClickedDoneButton() {
        dismissKeyboard()
        viewModel.addOrUpdateContact()
    }
}

//MARK: - Helper Methods
private extension AddContactController {
    func setupInterface() {
        setupNavigationBar()
        contactNameContainerView.setGradientBackground(startColor: UIColor.white, endColor: UIColor.turquoiseLight)
        setupContactInfoContainerView()
    }
    
    func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(title: Constants.cancel, style: .plain, target: self, action: #selector(didClickedCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: Constants.done, style: .plain, target: self, action: #selector(didClickedDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func setupProperties() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        dismissKeypadOnTapOutside()
    }
    
    func setupBindings() {
        viewModel.reloadHandler = { [weak self] in
            self?.showContactAddedAlert()
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
    
    func setupContactInfoContainerView() {
        let itemListVC = Storyboard.main.instantiateVC(ItemListController.self)
        itemListVC.delegate = self
        itemListVC.enableEditing = true
        addChildVC(viewController: itemListVC, in: contactInfoContainerView)
    }
    
    func showContactAddedAlert() {
        let okAction: AlertAction = { [weak self] (action) in
            self?.popViewController()
        }
        showAlert(title: nil, message: viewModel.getContactAddedMessage(), actionTitles: [Constants.ok], actions: [okAction])
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - ItemList delegate methods
extension AddContactController: ItemListDelegate {
    func numberOfRows() -> Int {
        return viewModel.getNumberOfContactInfoDetails()
    }
    
    func itemDetails(for indexPath: IndexPath) -> (title: String, value: String?, inputType: InputType) {
        return viewModel.getContactInfoDetails(for: indexPath.row)
    }
    
    func didChangedValue(_ value: String, forType type: InputType) {
        viewModel.didChangedValue(value, forType: type)
    }
}

//MARK: - ImagePicker delegate methods
extension AddContactController: ImagePickerDelegate {
    func didSelectImage(_ image: UIImage?) {
        self.profilePicImageView.image = image
    }
}
