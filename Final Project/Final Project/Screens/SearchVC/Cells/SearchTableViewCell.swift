//
//  SearchTableViewCell.swift
//  Final Project
//
//  Created by Andrey on 12.09.21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var posterImageView: UIImageView!
  
  static let cellName = "SearchTableViewCell"
  
  func setupMovie(info: MovieInfo) {
    nameLabel.text = info.title
    posterImageView.downloaded(from: info.poster)
    posterImageView.layer.cornerRadius = 5
  }
  
  func setupMovie(title: String) {
    nameLabel.text = title
  }
}
