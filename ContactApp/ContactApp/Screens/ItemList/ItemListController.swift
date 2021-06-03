//
//  ItemListController.swift
//  ContactApp
//
//  Created by Midhunlal M on 15/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

protocol ItemListDelegate: class {
    func numberOfRows() -> Int
    func itemDetails(for indexPath: IndexPath) -> (title: String, value: String?, inputType: InputType)
    func didChangedValue(_ value: String, forType type: InputType)
}
extension ItemListDelegate {
    func didChangedValue(_ value: String, forType type: InputType) {}
}

class ItemListController: BaseController {
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ItemListDelegate?
    var enableEditing: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
        super.viewWillDisappear(animated)
    }
}

private extension ItemListController {
    func setupProperties() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.registerNib(ItemCell.self)
        
        scrollView = tableView
    }
}

extension ItemListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ItemCell.self, indexPath: indexPath)
        if let details = delegate?.itemDetails(for: indexPath) {
            cell.configure(inputType: details.inputType, title: details.title, value: details.value, enableEditing: enableEditing)
        }
        cell.textFieldDidBeginEditing = { [weak self] (textField) in
            self?.activeTextField = textField
        }
        cell.textFieldDidEndEditing = { [weak self] (textField, inputType) in
            self?.activeTextField = nil
            guard let text = textField?.text, text.count > 0 else { return }
            self?.delegate?.didChangedValue(text, forType: inputType)
        }
        cell.textFieldShouldReturn = { [weak self] in
            self?.dismissKeyboard()
            return true
        }
        return cell
    }
}

extension ItemListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !enableEditing { return }
        if let currentCell = tableView.cellForRow(at: indexPath) as? ItemCell {
            currentCell.valueTextField.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
