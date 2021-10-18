//
//  HistoryVC.swift
//  Final Project
//
//  Created by Andrey on 10.10.21.
//

import UIKit
import Firebase

class HistoryVC: UIViewController {
  
  @IBOutlet private weak var historyTableView: UITableView!
  
  private var viewModel: HistoryViewModelProtocol = HistoryViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    historyTableView.delegate = self
    historyTableView.dataSource  = self
    historyTableView.register(UINib(nibName: SearchTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.cellName)
    
    viewModel.getDataFromFirebase()
    clearNavigationBar()
    bind()
  }
  
  private func bind() {
    viewModel.moviesDidChange = {
      self.historyTableView.reloadData()
    }
    
    viewModel.idsDidChange = {
      self.historyTableView.reloadData()
    }
    
    viewModel.namesDidChange = {
      self.historyTableView.reloadData()
    }
  }
  
  // MARK: - NavigationBar
  private func clearNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
  }
  
  private func configureItems(_ vc: UIViewController) {
    let image = UIImage(systemName: "chevron.backward")
    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                          style: .done,
                                                          target: self,
                                                          action: #selector(didTapBatton))
    navigationController?.navigationBar.tintColor = .systemGray5
  }
  
  @objc func didTapBatton() {
    navigationController?.popViewController(animated: true)
  }
  
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
  
  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.names.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellName, for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
    cell.setupMovie(title: viewModel.names[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movieId = viewModel.ids[indexPath.row]
    let nextVC = DetailsVC(nibName: "DetailsVC", bundle: nil)
    self.configureItems(nextVC)
    
    nextVC.viewModel.loadMovie(movieId: movieId)
    nextVC.viewModel.loadCast(movieId)
    nextVC.viewModel.loadReviews(movieId)
    
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
}
