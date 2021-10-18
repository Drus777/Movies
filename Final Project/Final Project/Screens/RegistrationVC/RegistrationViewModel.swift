//
//  RegistrationViewModel.swift
//  Final Project
//
//  Created by Andrey on 6.10.21.
//

import UIKit
import Firebase
import Locksmith

protocol RegistrationViewModelProtocol {
  func createUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Bool) -> ())
}

final class RegistrationViewModel: RegistrationViewModelProtocol {
  
  var success: Bool = false
  
  func createUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Bool) -> ()) {
    
    Auth.auth().createUser(withEmail: email, password: password) { [weak self ] result, error in
      
      if let result = result {
        self?.addNewDocumentInFirebase(firstName: firstName, lastName: lastName, userUid: result.user.uid, email: email, password: password) {
          if let success = self?.success {
            completion(success)
          }
        }
      }
      
      else if let error = error {
        self?.success = false
        if let success = self?.success {
          completion(success)
        }
        print("\(#function) error handled: \(error.localizedDescription)")
      }
    }
  }
  
  private func addNewDocumentInFirebase(firstName: String, lastName: String, userUid: String, email: String, password: String, completion: @escaping () -> ()){
    let db = Firestore.firestore()
    
    let newDocument = db.collection("users").document(userUid)
    newDocument.setData([
      "firstName": firstName,
      "lastName": lastName,
      "uid": userUid,
      "avatarURL": " "
    ]) { error in
      if error != nil {
        self.success = false
        completion()
      }
      else {
        self.success = true
        completion()
      }
    }
  }
  
  
  
}
