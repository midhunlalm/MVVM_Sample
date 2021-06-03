//
//  BaseController.swift
//  ContactApp
//
//  Created by Midhunlal M on 13/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import UIKit

typealias AlertAction = ((UIAlertAction) -> Void)?

class BaseController: UIViewController {
    private var activityView: UIActivityIndicatorView?
    var activeTextField: UITextField?
    var activeTextView: UITextView?
    var scrollView: UIScrollView?
    var screenTitle: String? {
        didSet {
            self.navigationItem.title = screenTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Loader Handling
extension BaseController {
    func showLoader(inView view: UIView?) {
        guard let view = view else { return }
        
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        activityView = activityIndicator
    }
    
    func hideLoader() {
        activityView?.removeFromSuperview()
    }
}

//MARK: - Alerts
extension BaseController {
    /**
     @abstract Method to show alert with title and message with ok button.
     */
    func showAlert(title: String?, message: String?) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: Constants.ok, style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    /**
     @abstract Method to show alert with variable number of buttons with action.
     Make sure that the array of actionTitle and action should be same, otherwise crash will occur.
     If no action is required for a button, then pass nil in action the respective index.
     - parameter title, message, actionTitles, actions
     */
    func showAlert(title: String?, message: String?, actionTitles:[String?], actions:[AlertAction]) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alertVC.addAction(action)
        }
        present(alertVC, animated: true, completion: nil)
    }
    
    /**
     @abstract Method to show alert for error.
     */
    func showAlert(error: Error?) {
        guard let error = error else { return }
        showAlert(title: Constants.error, message: error.localizedDescription)
    }
}

// MARK: - Keyboard Handling
extension BaseController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_: )),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_: )),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func dismissKeypadOnTapOutside() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    /**
     @abstract Method to handle scrolling when keyboard is appeared. Need to set active textField/ textView and scrollview for keyboard handling
     Overridding this method only if you are using custom keyboard(if the height is bigger than default),
     */
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        var keyboardRect = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardRect = view.convert(keyboardRect, from: nil)
        
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardRect.size.height, right: 0.0)
        scrollView?.contentInset = contentInset
        scrollView?.scrollIndicatorInsets = contentInset
        if let frame  = activeTextField?.frame, let viewRect = scrollView?.convert(frame, from: activeTextField?.superview) {
            scrollView?.scrollRectToVisible(viewRect, animated: true)
        } else if let frame = activeTextView?.frame, let viewRect = scrollView?.convert(frame, from: activeTextView?.superview) {
            scrollView?.scrollRectToVisible(viewRect, animated: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView?.contentInset = UIEdgeInsets.zero
        scrollView?.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
