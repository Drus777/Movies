//
//  SearchVC.swift
//  Final Project
//
//  Created by Andrey on 12.09.21.
//

import UIKit

final class SearchVC: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var searchBar: UISearchBar!
  
  var viewModel: SearchViewModelProtocol = SearchViewModel()
  
  private var timer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupSearchBar()
    clearNavigationBar()
    bind()
    
    searchBar.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchBar.becomeFirstResponder()
  }
  
  private func setupTableView(){
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: SearchTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.cellName)
  }
  
  private func setupSearchBar() {
    searchBar.delegate = self
  }
  
  // MARK: - NavigationBar
  private func clearNavigationBar(){
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
  
  private func bind() {
    viewModel.moviesDidChange = {
      self.tableView.reloadData()
    }
    
  }
  
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
  
  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellName, for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
    cell.setupMovie(info: viewModel.movies[indexPath.row])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = DetailsVC(nibName: "DetailsVC", bundle: nil)
    guard let movieId = viewModel.movies[indexPath.row].id else { return }
    nextVC.viewModel.loadMovie(movieId: String(movieId))
    nextVC.viewModel.loadCast(String(movieId))
    nextVC.viewModel.loadReviews(String(movieId))
    configureItems(nextVC)
    navigationController?.pushViewController(nextVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return (UIScreen.main.bounds.height - 90) / 9
  }
  
}

extension SearchVC: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    view.endEditing(true)
  }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
      
      self?.viewModel.findMovie(searchText)
      
    })
    
  }
}
