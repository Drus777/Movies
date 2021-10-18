//
//  MainMenuViewModel.swift
//  Final Project
//
//  Created by Andrey on 23.09.21.
//

import UIKit

enum MoviePath: String, CaseIterable {
  
  case popular = "/movie/popular"
  case topRated = "/movie/top_rated"
  case upcoming = "/movie/upcoming"
  
  var name: String {
    switch self {
    case .popular: return "Popular"
    case .topRated: return "Top Rated"
    case .upcoming: return "Upcoming"
    }
  }
}

protocol MainMenuViewModelProtocol {
  var numberOfRows: Int { get }
  var allCategoryDidChange: (() -> Void)? { get set }
  var genresDictionary: [Int: String] { get }
  
  var genresDictionaryDidChange: (() -> Void)? { get set }
  
  func dataForIndexPath(_ indexPath: IndexPath) -> Category
  func loadGenresOfMovie()
}

final class MainMenuViewModel: MainMenuViewModelProtocol{
  
  let networkService = NetworkService()
  
  var numberOfRows: Int {
    allCategory.count
  }
  
  private var allCategory: [Category] = MoviePath.allCases.map { Category(name: $0.name, url: $0.rawValue) } {
    didSet{
      allCategoryDidChange?()
    }
  }
  
  var genresDictionary: [Int: String] = [:] {
    didSet {
      genresDictionaryDidChange?()
    }
  }
  
  var allCategoryDidChange: (() -> Void)?
  var genresDictionaryDidChange: (() -> Void)?
  
  func dataForIndexPath(_ indexPath: IndexPath) -> Category {
    return allCategory[indexPath.row]
  }
  
  func loadGenresOfMovie() {
    let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=83224e1665f2c91754d1c03ad23dd491")
    
    networkService.load(url: url, model: GenresOfMovie.self) { genres, error in
      if let genres = genres {
        genres.genres.forEach {
          self.genresDictionary[$0.id] = $0.name
        }
      } else if let error = error {
        print("\(#function) error handled: \(error.localizedDescription)")
      }
    }
  }
  
}
