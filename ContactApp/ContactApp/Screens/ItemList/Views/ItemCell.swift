//
//  ItemCell.swift
//  ContactApp
//
//  Created by Midhunlal M on 15/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    private var inputType: InputType = .default
    var textFieldDidBeginEditing: ((UITextField?) -> Void)?
    var textFieldDidEndEditing: ((UITextField?, InputType) -> Void)?
    var textFieldShouldReturn: (() -> Bool)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        valueTextField.delegate = self
    }

    func configure(inputType: InputType, title: String, value: String?, enableEditing: Bool) {
        self.inputType = inputType
        titleLabel.text = title
        valueTextField.text = value
        valueTextField.isUserInteractionEnabled = enableEditing
        if enableEditing {
            valueTextField.placeholder = Constants.enter + " " + title.lowercased()
        }
        if inputType == .phoneNo {
            valueTextField.keyboardType = .phonePad
        }
    }
}

extension ItemCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textFieldDidBeginEditing = textFieldDidBeginEditing else {
            return
        }
        textFieldDidBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textFieldDidEndEditing = textFieldDidEndEditing else {
            return
        }
        textFieldDidEndEditing(textField, inputType)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFieldShouldReturn = textFieldShouldReturn else {
            return true
        }
        return textFieldShouldReturn()
    }
}
