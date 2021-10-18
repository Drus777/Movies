//
//  MenuTableViewCellViewModel.swift
//  Final Project
//
//  Created by Andrey on 23.09.21.
//

import UIKit
import Firebase

protocol MenuTableViewCellViewModelProtocol {
  var movies: [MovieInfo] { get }
  var genresDictionary: [Int: String] { get set }
  var moviesDidChange: (() -> Void)? { get set }
  var genresDictionaryDidChange: (() -> Void)? { get set }
  
  func loadMovies(_ url: String?)
  func getGenreName(_ indexPath: IndexPath) -> String
}

final class MenuTableViewCellViewModel: MenuTableViewCellViewModelProtocol{
  
  let networkService = NetworkService()
  
  var genresDictionary: [Int : String] = [:] {
    didSet {
      genresDictionaryDidChange?()
    }
  }
  
  var movies: [MovieInfo] = [] {
    didSet{
      moviesDidChange?()
    }
  }
  
  var moviesDidChange: (() -> Void)?
  var genresDictionaryDidChange: (() -> Void)?
  
  func getGenreName(_ indexPath: IndexPath) -> String {
    guard
      let genresId = movies[indexPath.item].genre,
      let genreName = genresDictionary[genresId[0]]
    else {return ""}
    
    return genreName
  }
  
  func loadMovies(_ urlString: String?) {
    
    guard let urlString = urlString else {return}
    let url = "https://api.themoviedb.org/3\(urlString)?api_key=83224e1665f2c91754d1c03ad23dd491"
    
    networkService.load(url: URL(string: url), model: MoviesResponce.self) { [weak self] movies, error in
      if let movies = movies {
          self?.movies = movies.results
      } else if let error = error {
        print("\(#function) error handled: \(error.localizedDescription)")
      }
    }
  }
  
}
