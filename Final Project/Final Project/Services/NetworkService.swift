//
//  NetworkService.swift
//  Final Project
//
//  Created by Andrey on 25.09.21.
//

import UIKit

class NetworkService {
  
  static var cache: [URL: Codable] = [:]
  
  func load<T: Codable>(url: URL?, model: T.Type, completion: @escaping (T?, Error?) -> Void) {
    guard let url = url else { return }
    
    if let result: T = NetworkService.cache[url] as? T {
      DispatchQueue.main.async {
        completion(result, nil)
      }
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { responseData, response, error in
      if let data = responseData {
        do {
          let result = try JSONDecoder().decode(model.self, from: data)
          NetworkService.cache[url] = result
          DispatchQueue.main.async {
            completion(result, error)
          }
        }
        catch {
          print(error)
        }
        
      } else {
        completion(nil, error)
      }
    }.resume()
  }
}
