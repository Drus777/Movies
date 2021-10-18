//
//  CastCollectionViewCell.swift
//  Final Project
//
//  Created by Andrey on 30.09.21.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var castImageView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  
  static let cellName = "CastCollectionViewCell"
  
  override func prepareForReuse() {
    super.prepareForReuse()
    castImageView.image = UIImage(named: "no image")
  }
  
  func setup (actorInfo: ActorInfo) {
    castImageView.downloaded(from: actorInfo.profilePath)
    guard let name = actorInfo.name else {return}
    let actorName = name.components(separatedBy: " ")
    
    if actorName.count == 2 {
      nameLabel.text = "\(actorName[0])\r\(actorName[1])"
    } else if actorName.count == 1{
      nameLabel.text = name
    }
    
  }
  
}
