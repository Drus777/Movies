//
//  LoginViewModel.swift
//  Final Project
//
//  Created by Andrey on 7.10.21.
//

import UIKit
import Firebase
import Locksmith

protocol LoginViewModelProtocol {
  func signIn(email: String, password: String, completion: @escaping (Bool) -> ())
}

final class LoginViewModel: LoginViewModelProtocol {
  
  var success: Bool = true
  
  func signIn(email: String, password: String, completion: @escaping (Bool) -> ()) {
    
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      if result != nil {
        
        guard let userUid = result?.user.uid else { return }
        self.saveDataIntKeyChain(email: email, password: password, userUid: userUid)
        
        self.success = true
        completion(self.success)
        
      } else if let error = error{
        self.success = false
        completion(self.success)
        print("\(#function) error handled: \(error.localizedDescription)")
      }
    }
    
  }
  
  private func saveDataIntKeyChain(email: String, password: String, userUid: String){
    do {
      try Locksmith.saveData(data: ["email" : email, "password": password], forUserAccount: userUid)
    } catch {
      print(#function, "Unable to save data")
    }
  }
  
}
