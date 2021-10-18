
import UIKit

final class FilmsCollectionViewCell: UICollectionViewCell {
  
  static let cellName = "FilmsCollectionViewCell"
  
  @IBOutlet private weak var filmImageView: UIImageView!
  @IBOutlet private weak var filmNameLabel: UILabel!
  @IBOutlet private weak var ganreLabel: UILabel!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    filmImageView.image = nil
  }
  
  func setup(info: MovieInfo, genre: String) {
    filmImageView.layer.cornerRadius = 5
    filmNameLabel.text = info.title
    ganreLabel.text = genre
    filmImageView.downloaded(from: info.poster)
  }
}
