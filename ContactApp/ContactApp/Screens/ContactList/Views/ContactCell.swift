//
//  ContactCell.swift
//  ContactApp
//
//  Created by Midhunlal M on 14/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var viewModel: ContactCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.whiteSmoke
    }
    
    func configure(with viewModel: ContactCellViewModel?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel
        contactNameLabel.text = viewModel.contactName
        favoriteButton.isHidden = !viewModel.isFavorite
        if let imageUrl = viewModel.profilePicUrl {
            profilePicImageView.setImageFromUrlString(imageUrl)
        }
    }
}
