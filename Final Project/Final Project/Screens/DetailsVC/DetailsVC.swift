//
//  DetailsVC.swift
//  Final Project
//
//  Created by Andrey on 25.09.21.
//

import UIKit
import Firebase

final class DetailsVC: UIViewController {
  
  @IBOutlet weak var navBarView: UIView!
  @IBOutlet private weak var detailsTableView: UITableView!
  
  var viewModel: DetailsViewModelProtocol = DetailsViewModel()
  
  private let headerView = HeaderView()
  static let tableViewRowHeight = UIScreen.main.bounds.height / 1.6
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    load()
    bind()
  }
  
  private func setupTableView() {
    detailsTableView.register(UINib(nibName: DetailsTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: DetailsTableViewCell.cellName)
    detailsTableView.register(UINib(nibName: CastTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: CastTableViewCell.cellName)
    
    detailsTableView.dataSource = self
    detailsTableView.delegate = self
    
    //setup HeaderView
    headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width / 2)
    detailsTableView.tableHeaderView = headerView
    
  }
  
  private func bind() {
    viewModel.movieDidChange = {
      self.detailsTableView.reloadData()
    }
    
    viewModel.castDidChange = { [weak self] in
      guard
        let movie = self?.viewModel.movie,
        let id = movie.id,
        let title = movie.title
      else { return }
      
      self?.headerView.setup(url: movie.backdropPath ?? "")
      self?.viewModel.uploadHistoryToFirebase(id: String(id), name: title)
      self?.detailsTableView.reloadData()
    }
    
    viewModel.reviewsDidChange = {
      self.detailsTableView.reloadData()
    }
  }
  
  private func load() {
    guard let id = viewModel.movie?.id else {return}
    viewModel.loadCast("\(id)")
    viewModel.loadReviews("\(id)")
  }
  
}

extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let header = detailsTableView.tableHeaderView as? HeaderView else {return}
    header.scrollViewDidScroll(scrollView: detailsTableView)
    
    navBarView.alpha = scrollView.contentOffset.y / 160
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.cellName) as? DetailsTableViewCell else {return UITableViewCell()}
      
      guard let movie = viewModel.movie else {return UITableViewCell()}
      cell.setup(info: movie, genre: viewModel.getGenreName())
      
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.cellName) as? CastTableViewCell else {return UITableViewCell()}
      cell.setupWithViewModel(viewModel.cast, viewModel.reviews)
      
      return cell
    default: break
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.row {
    case 0:
      return DetailsVC.tableViewRowHeight
    case 1:
      return DetailsVC.tableViewRowHeight / 2
      
    default: break
    }
    
    return 0
  }
  
  
}
