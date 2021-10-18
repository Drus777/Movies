//
//  DetailsTableViewCell.swift
//  Final Project
//
//  Created by Andrey on 26.09.21.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var posterImageView: UIImageView!
  @IBOutlet private weak var titleLable: UILabel!
  @IBOutlet private weak var voteLable: UILabel!
  @IBOutlet private weak var languageLable: UILabel!
  @IBOutlet private weak var dateLable: UILabel!
  @IBOutlet private weak var genreLabel: UILabel!
  @IBOutlet private weak var overviewTextView: UITextView!
  
  static let cellName = "DetailsTableViewCell"  
  
  func setup(info: MovieDetailsResponce, genre: String) {
    posterImageView.downloaded(from: info.poster)
    titleLable.text = info.title
    
    guard let vote = info.voteAverage else {return}
    voteLable.text = "\(vote)"
    voteLable.textColor = vote > 5.5 ? .systemGreen : .systemRed
    
    genreLabel.text = genre
    dateLable.text = info.releaseDate
    overviewTextView.text = info.overview
  }
  
}
