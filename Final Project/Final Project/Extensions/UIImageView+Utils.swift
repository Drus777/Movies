//
//  UIImage+Utils.swift
//  Final Project
//
//  Created by Andrey on 25.09.21.
//

import UIKit

extension UIImageView {
  func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
    contentMode = mode
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
      else { return }
      DispatchQueue.main.async() { [weak self] in
        self?.image = image
      }
    }.resume()
  }
  func downloaded(from link: String?, contentMode mode: ContentMode = .scaleAspectFill) {
    
    guard
      let link = link,
      let url = URL(string: "https://image.tmdb.org/t/p/w500\(link)")
    else { return }
    downloaded(from: url, contentMode: mode)
  }
  
  func downloadedFromFirebase(from link: String?, contentMode mode: ContentMode = .scaleAspectFill) {
    
    guard
      let link = link,
      let url = URL(string: link)
    else { return }
    downloaded(from: url, contentMode: mode)
  }
}
