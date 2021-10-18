import UIKit

protocol MenuTableViewCellDelegate: AnyObject {
  func didSelect(_ movie: MovieInfo)
}

final class MenuTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var categoryNameLabel: UILabel!
  
  static let cellName = "MenuTableViewCell"
  
  weak var delegate: MenuTableViewCellDelegate?
  
  var viewModel: MenuTableViewCellViewModelProtocol = MenuTableViewCellViewModel()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UINib(nibName: FilmsCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: FilmsCollectionViewCell.cellName)
    bind()
  }
  
  private func bind() {
    viewModel.moviesDidChange = {
      self.collectionView.reloadData()
    }
    viewModel.genresDictionaryDidChange = {
      self.collectionView.reloadData()
    }
  }
  
  func setup(category: Category?) {
    viewModel.loadMovies(category?.url)
    categoryNameLabel.text = category?.name
  }
  
}

extension MenuTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  //MARK: -UICollectionViewDelegate
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmsCollectionViewCell.cellName, for: indexPath) as? FilmsCollectionViewCell else {return UICollectionViewCell()}
    cell.setup(info: viewModel.movies[indexPath.item], genre: viewModel.getGenreName(indexPath))
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelect(viewModel.movies[indexPath.row])
  }
  
  //MARK: -UICollectionViewDelegateFlowLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (UIScreen.main.bounds.width - 10) / 3, height: (UIScreen.main.bounds.height - 150) / 3)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
  }
  
}
