//
//  RegistrationVC.swift
//  Final Project
//
//  Created by Andrey on 6.10.21.
//

import UIKit
import FirebaseAuth
import Firebase
import Locksmith

final class RegistrationVC: UIViewController {
  
  @IBOutlet private weak var firstNameTextField: UITextField!
  @IBOutlet private weak var lastNameTextField: UITextField!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var errorLabel: UILabel!
  
  var viewModel: RegistrationViewModelProtocol = RegistrationViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    firstNameTextField.delegate = self
    lastNameTextField.delegate = self
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }
  
  @IBAction func signUpButtonDidTapped() {
    errorLabel.text = checkValid()
    guard
      let firstName = firstNameTextField.text,
      let lastName = lastNameTextField.text,
      let email = emailTextField.text,
      let password = passwordTextField.text
    else {return}
  
    viewModel.createUser(firstName: firstName, lastName: lastName, email: email, password: password) { [weak self] success in

        switch success {
        case true:
          self?.setupAlert(title: "Success", message: "You are registered") {
            self?.navigationController?.popViewController(animated: true)
          }
          
        case false:
          self?.setupAlert(title: "Error", message: "Error saving user in database") {
            self?.dismiss(animated: true, completion: nil)
          }
        }

    }
  }
  
  private func setupAlert(title: String, message: String, completion: @escaping () -> ()){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okButton = UIAlertAction(title: "ok", style: .default) { action in
      completion()
    }
    alert.addAction(okButton)
    self.present(alert, animated: true, completion: nil)
  }
  
  private func checkValid() -> String? {
    if firstNameTextField.text != "",
       lastNameTextField.text != "",
       emailTextField.text != "",
       passwordTextField.text != ""{
      return ""
    } else {
      return "Please fill in all fiels"
    }
  }
  
}

extension RegistrationVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if firstNameTextField.isFirstResponder {
      lastNameTextField.becomeFirstResponder()
    } else if lastNameTextField.isFirstResponder {
      emailTextField.becomeFirstResponder()
    } else if emailTextField.isFirstResponder {
      passwordTextField.becomeFirstResponder()
    } else {
      passwordTextField.resignFirstResponder()
    }
    
    return true
  }
}
