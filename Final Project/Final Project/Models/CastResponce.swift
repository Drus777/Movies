//
//  Cast.swift
//  Final Project
//
//  Created by Andrey on 30.09.21.
//

import UIKit

struct ActorInfo: Codable {
    var name: String?
    var profilePath: String?
    
    enum CodingKays: String, CodingKey {
        case name
        case profilePath = "profile_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKays.self)
        self.name = try container.decode(Optional<String>.self, forKey: .name)
        self.profilePath = try container.decode(Optional<String>.self, forKey: .profilePath)
    }
}

struct CastResponce: Codable {
  var id: Int?
  var cast: [ActorInfo]
}
