//
//  ProfileViewModel.swift
//  Final Project
//
//  Created by Andrey on 9.10.21.
//

import UIKit
import FirebaseStorage
import Firebase
import Locksmith

protocol ProfileViewModelProtocol {
  var fullName: String { get }
  var userUid: String { get }
  
  func upload(userId: String, photo: UIImageView, completion: @escaping (Result<URL, Error>) -> ())
  func getProfileFromFirebase(profileClosure: @escaping (UserProfile) -> Void)
  func singIn()
}

struct UserProfile {
  var fullname: String?
  var avatarURL: String?
}

class ProfileViewModel: ProfileViewModelProtocol {
  
  var fullName = ""
  var userUid = ""
  
  func upload(userId: String, photo: UIImageView, completion: @escaping (Result<URL, Error>) -> ()){
    
    let reference = Storage.storage().reference().child("avatars").child(userId)
    
    guard let imageData = photo.image?.jpegData(compressionQuality: 0.4) else { return }
    
    let metadata = StorageMetadata()
    metadata.contentType =  "image/jpeg"
    
    reference.putData(imageData, metadata: metadata) { metadata, error in
      guard let _ = metadata else {
        completion(.failure(error!))
        return
      }
      reference.downloadURL { url, error in
        guard let url = url else {
          completion(.failure(error!))
          return
        }
        completion(.success(url))
      }
    }
  }
  
  func getProfileFromFirebase(profileClosure: @escaping (UserProfile) -> Void) {
    let currentUser = Auth.auth().currentUser
    guard let user = currentUser else { return }
    userUid = user.uid
    let db = Firestore.firestore()
    let docRef = db.collection("users").document(user.uid)
    
    docRef.getDocument { document, error in
      if let document = document, document.exists {
        
        guard
          let documentData = document.data(),
          let avatarUrl = documentData["avatarURL"] as? String,
          let name = documentData["firstName"] as? String,
          let lastName = documentData["lastName"] as? String
        else { return }
        let profile = UserProfile(fullname: name + " " + lastName,
                                  avatarURL: avatarUrl)
        profileClosure(profile)
      }
    }
  }
  
  func singIn() {
    
    let dict = Locksmith.loadDataForUserAccount(userAccount: self.userUid)
    guard
      let dictData = dict,
      let email = dictData["email"] as? String,
      let password = dictData["password"] as? String
    else {return}
    
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      if let  error = error {
        print("\(#function) error handled: \(error.localizedDescription)")
      }
    }
    
  }
}


