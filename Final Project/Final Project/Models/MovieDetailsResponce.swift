//
//  MovieDetailsResponce.swift
//  Final Project
//
//  Created by Andrey on 10.10.21.
//

import UIKit

struct Genres: Codable {
  var id: Int?
  var name: String?
}

struct MovieDetailsResponce: Codable {
    
  var poster: String?
  var id: Int?
  var title: String?
  var backdropPath: String?
  var genres: [Genres]?
  var overview: String?
  var releaseDate: String?
  var originalLanguage: String?
  var voteAverage: Double?
  
  enum CodingKays: String, CodingKey {
      case poster = "poster_path"
      case id
      case title
      case backdropPath = "backdrop_path"
      case overview
      case genres
      case releaseDate = "release_date"
      case originalLanguage = "original_language"
      case voteAverage = "vote_average"
  }
  
  init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKays.self)
      self.poster = try container.decode(String.self, forKey: .poster)
      self.id = try container.decode(Int.self, forKey: .id)
      self.title = try container.decode(String.self, forKey: .title)
      self.backdropPath = try container.decode(String.self, forKey: .backdropPath)
      self.genres = try container.decode([Genres].self, forKey: .genres)
      self.overview = try container.decode(String.self, forKey: .overview)
      self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
      self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
      self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
  }
    
}

