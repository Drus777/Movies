//
//  HistoryViewModel.swift
//  Final Project
//
//  Created by Andrey on 10.10.21.
//

import UIKit
import Firebase

protocol HistoryViewModelProtocol {
  var movies: [MovieInfo] { get }
  var ids: [String] { get }
  var names: [String] { get }
  var moviesDidChange: (() -> Void)? { get set }
  var idsDidChange: (() -> Void)? { get set }
  var namesDidChange: (() -> Void)? { get set }
  
  func getDataFromFirebase()
}

class HistoryViewModel: HistoryViewModelProtocol {
  
  var movies: [MovieInfo] = [] {
    didSet{
      moviesDidChange?()
    }
  }
  
  var ids: [String] = [] {
    didSet{
      idsDidChange?()
    }
  }
  
  var names: [String] = [] {
    didSet{
      namesDidChange?()
    }
  }
  
  var moviesDidChange: (() -> Void)?
  var idsDidChange: (() -> Void)?
  var namesDidChange: (() -> Void)?
  
  func getDataFromFirebase() {
    let currentUser = Auth.auth().currentUser
    guard let user = currentUser else {return}
    
    let db = Firestore.firestore()
    let docRef = db.collection("users").document(user.uid)
    docRef.getDocument { doc, _ in
      let documentData = doc?.data()
      if let history = documentData?["history"] as? [String: Any] {
        if let ids = history["id"] as? [String],
           let names = history["name"] as? [String]
        {
          self.ids = ids
          self.names = names
        }
      }
    }
  }
  
}

