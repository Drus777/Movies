//
//  ReviewsResponce.swift
//  Final Project
//
//  Created by Andrey on 5.10.21.
//

import UIKit

struct AuthorInfo: Codable {
  var avatarPath: String?
  
  enum CodingKays: String, CodingKey {
    case avatarPath = "avatar_path"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKays.self)
    self.avatarPath = try container.decode(Optional<String>.self, forKey: .avatarPath)
  
  }
}

struct Review: Codable {
  var author: String?
  var authorDetails: AuthorInfo
  var content: String?
  
  enum CodingKays: String, CodingKey {
    case author
    case authorDetails = "author_details"
    case content
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKays.self)
    self.author = try container.decode(Optional<String>.self, forKey: .author)
    self.authorDetails = try container.decode(AuthorInfo.self, forKey: .authorDetails)
    self.content = try container.decode(Optional<String>.self, forKey: .content)
  }
  
}

struct ReviewsResponce: Codable {
  var results: [Review]
}
