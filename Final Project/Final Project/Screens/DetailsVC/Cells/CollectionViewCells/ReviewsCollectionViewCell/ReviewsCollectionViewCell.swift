//
//  ReviewsCollectionViewCell.swift
//  Final Project
//
//  Created by Andrey on 5.10.21.
//

import UIKit

final class ReviewsCollectionViewCell: UICollectionViewCell {

  @IBOutlet private weak var avatarImageView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var reviewTextView: UITextView!
  
  static let cellName = "ReviewsCollectionViewCell"
  
  func setup(_ review: Review) {
    avatarImageView.downloaded(from: review.authorDetails.avatarPath)
    avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    nameLabel.text = review.author
    reviewTextView.text = review.content
  }
  
}
