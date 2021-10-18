//
//  HistoryTableViewCell.swift
//  Final Project
//
//  Created by Andrey on 10.10.21.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var movieImageView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!

  static let cellName = "HistoryTableViewCell"
  
  func setup(info: MovieInfo){
    movieImageView.downloaded(from: info.poster)
    nameLabel.text = info.title
  }
  
}
