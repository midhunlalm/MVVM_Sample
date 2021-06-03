//
//  ContactDetailController.swift
//  ContactApp
//
//  Created by Midhunlal M on 15/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailController: BaseController {
    @IBOutlet weak var contactNameContainerView: UIView!
    @IBOutlet weak var contactInfoContainerView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var viewModel: ContactDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    //MARK: - Button Actions
    @IBAction func didClickedMessageButton(_ sender: Any) {
        guard let phoneNo = viewModel.contactPhoneNumber, MFMessageComposeViewController.canSendText() else { return }
        let composeMessageVC = MFMessageComposeViewController()
        composeMessageVC.messageComposeDelegate = self
        composeMessageVC.recipients = [phoneNo]
        self.present(composeMessageVC, animated: true, completion: nil)
    }
    
    @IBAction func didClickedCallButton(_ sender: Any) {
        guard let phoneNo = viewModel.contactPhoneNumber, let url = URL(string: "tel://\(phoneNo)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didClickedEmailButton(_ sender: Any) {
        guard let email = viewModel.contactEmail, MFMailComposeViewController.canSendMail() else { return }
        let composeMailVC = MFMailComposeViewController()
        composeMailVC.mailComposeDelegate = self
        composeMailVC.setToRecipients([email])
        self.present(composeMailVC, animated: true, completion: nil)
    }
    
    @IBAction func didClickedFavouriteButton(_ sender: Any) {
        favouriteButton.isSelected = !favouriteButton.isSelected
        viewModel.didUpdateContactFavouriteStatus(favouriteButton.isSelected)
    }
    
    @objc func didClickedEditButton() {
        let addContactVC = Storyboard.main.instantiateVC(AddContactController.self)
        addContactVC.viewModel = viewModel.getAddContactViewModel()
        navigationController?.pushViewController(addContactVC, animated: true)
    }
}

//MARK: - Helper Methods
private extension ContactDetailController {
    func setupInterface() {
        setupNavigationBar()
        contactNameContainerView.setGradientBackground(startColor: UIColor.white, endColor: UIColor.turquoiseLight)
        contactNameLabel.text = viewModel.contactName
        if let imageUrl = viewModel.profilePicUrl {
            profilePicImageView.setImageFromUrlString(imageUrl)
        }
        favouriteButton.isSelected = viewModel.isFavorite
        
    }
    
    func setupNavigationBar() {
        let editButton = UIBarButtonItem(title: Constants.edit, style: .plain, target: self, action: #selector(didClickedEditButton))
        navigationItem.rightBarButtonItem = editButton
    }
    
    func setupBindings() {
        viewModel.reloadHandler = { [weak self] in
            self?.updateInterface()
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
    
    func updateInterface() {
        setupContactInfoContainerView()
    }
    
    func setupContactInfoContainerView() {
        let itemListVC = Storyboard.main.instantiateVC(ItemListController.self)
        itemListVC.delegate = self
        itemListVC.enableEditing = false
        addChildVC(viewController: itemListVC, in: contactInfoContainerView)
    }
}

//MARK: - ItemList delegate methods
extension ContactDetailController: ItemListDelegate {
    func numberOfRows() -> Int {
        return viewModel.getNumberOfContactInfoDetails()
    }
    
    func itemDetails(for indexPath: IndexPath) -> (title: String, value: String?, inputType: InputType) {
        return viewModel.getContactInfoDetails(for: indexPath.row)
    }
}

//MARK: - MessageUI delegate methods
extension ContactDetailController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
