//
//  LoginVC.swift
//  Final Project
//
//  Created by Andrey on 6.10.21.
//

import UIKit
import FirebaseAuth
import Firebase

final class LoginVC: UIViewController {
  
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var errorLabel: UILabel!
  
  var viewModel: LoginViewModelProtocol  = LoginViewModel()

  @IBAction func loginButtonDidTapped() {
    
    errorLabel.text = checkValid()
    
    if checkValid() != "" {
      return
    }
    
    guard
      let email = emailTextField.text,
      let password = passwordTextField.text
    else {return}
    
    viewModel.signIn(email: email, password: password) { [weak self] success in
      switch success { 
      case true:
        self?.setupAlert(title: "Welcome!", message: "") {
          self?.navigationController?.popViewController(animated: true)
        }
      case false:
        self?.setupAlert(title: "Error", message: "Connection error") {
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
    if emailTextField.text != "",
       passwordTextField.text != ""{
      return ""
    } else {
      return "Please fill in all fiels"
    }
  }
  
  
}
