//
//  DetailsViewModel.swift
//  Final Project
//
//  Created by Andrey on 27.09.21.
//

import UIKit
import Firebase

protocol DetailsViewModelProtocol {
  var movie: MovieDetailsResponce? { get }
  var cast: [ActorInfo] { get }
  var reviews: [Review] { get }

  var castDidChange: (() -> Void)? { get set }
  var movieDidChange: (() -> Void)? { get set }
  var reviewsDidChange: (() -> Void)? { get set }
  
  func loadCast(_ id: String)
  func loadReviews(_ id: String)
  func getGenreName() -> String
  func loadMovie(movieId: String)
  func uploadHistoryToFirebase(id: String, name: String) 
}

final class DetailsViewModel: DetailsViewModelProtocol{
  
  let networkService = NetworkService()

  var cast: [ActorInfo] = [] {
    didSet{
      castDidChange?()
    }
  }
  
  var movie: MovieDetailsResponce? {
    didSet{
      movieDidChange?()
    }
  }
  
  var reviews: [Review] = [] {
    didSet{
      reviewsDidChange?()
    }
  }
  
  var movieDidChange: (() -> Void)?
  var castDidChange: (() -> Void)?
  var reviewsDidChange: (() -> Void)?
  
  func getGenreName() -> String {
    guard let genres = movie?.genres else { return ""}
    return genres.compactMap{ $0.name }.joined(separator: ", ")
  }
  
  func loadCast(_ id: String) {
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=83224e1665f2c91754d1c03ad23dd491")
    networkService.load(url: url, model: CastResponce.self) { [weak self] cast, error in
      if let cast = cast {
          self?.cast = cast.cast
      } else if let error = error {
        print(error.localizedDescription)
      }
    }
  }
  
  func loadReviews(_ id: String) {
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=83224e1665f2c91754d1c03ad23dd491")
    networkService.load(url: url, model: ReviewsResponce.self) { [weak self] reviews, error in
      if let reviews = reviews {
          self?.reviews = reviews.results
      } else if let error = error {
        print(error.localizedDescription)
      }
    }
  }
  
  func loadMovie(movieId: String) {
  
    let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=83224e1665f2c91754d1c03ad23dd491"
    
    networkService.load(url: URL(string: url), model: MovieDetailsResponce.self) { [weak self] movie, error in
      if let movie = movie {
          self?.movie = movie
      } else if let error = error {
        print("\(#function) error handled: \(error.localizedDescription)")
      }
    }
  }
  
  func uploadHistoryToFirebase(id: String, name: String) {
    let currentUser = Auth.auth().currentUser
    guard let user = currentUser else {return}
    
    let db = Firestore.firestore()
    let docRef = db.collection("users").document(user.uid)
    docRef.getDocument { doc, _ in
      let documentData = doc?.data()
      if let history = documentData?["history"] as? [String: Any] {
        if let oldID = history["id"] as? [String],
           let oldName = history["name"] as? [String]
        {
          docRef.updateData(["history": [
            "id": oldID + [id],
            "name": oldName + [name]
          ]])
        }
      } else {
        docRef.updateData(["history": [
          "id": [id],
          "name": [name]
        ]])
      }
    }
  }
  
}

