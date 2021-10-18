//
//  SearchViewModel.swift
//  Final Project
//
//  Created by Andrey on 27.09.21.
//

import UIKit

protocol SearchViewModelProtocol {
  var movies: [MovieInfo] { get }
  var moviesDidChange: (() -> Void)? { get set }
  
  func findMovie(_ searchPhrase: String)
}

final class SearchViewModel: SearchViewModelProtocol{
  
  let networkService = NetworkService()
  
  var movies: [MovieInfo] = [] {
    didSet{
      moviesDidChange?()
    }
  }
  
  var moviesDidChange: (() -> Void)?

  func findMovie(_ searchPhrase: String) {
    
    if searchPhrase.count > 0 {
      let urlString = "https://api.themoviedb.org/3/search/movie?api_key=83224e1665f2c91754d1c03ad23dd491&query=\(searchPhrase)"
      loadMovies(urlString)
    } else {
      movies = []
    }
  }
  
  private func loadMovies(_ url: String?) {
    guard let url = url else {return}
    networkService.load(url: URL(string: url), model: MoviesResponce.self) { [weak self] movies, error in
      if let movies = movies {
          self?.movies = movies.results
      } else if let error = error {
        print("\(#function) error handled: \(error.localizedDescription)")
      }
    }
  }
  
}
