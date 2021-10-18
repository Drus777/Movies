//
//  ViewController.swift
//  Final Project
//
//  Created by Andrey on 28.08.21.
//

import UIKit
import Firebase
final class MainMenuVC: UIViewController, MenuTableViewCellDelegate {
  
  @IBOutlet private weak var menuTableView: UITableView!
  @IBOutlet private weak var mainSearchBar: UISearchBar!
  
  private var viewModel: MainMenuViewModelProtocol = MainMenuViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.loadGenresOfMovie()
    setupTableView()
    clearNavigationBar()
    mainSearchBar.delegate = self
    bind()
  }
  
  private func bind() {
    viewModel.genresDictionaryDidChange = {
      self.menuTableView.reloadData()
    }
  }
  
  private func setupTableView(){
    menuTableView.register(UINib(nibName: MenuTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: MenuTableViewCell.cellName)
    menuTableView.dataSource = self
    menuTableView.delegate = self
  }
  
  func didSelect(_ movie: MovieInfo) {
    let nextVC = DetailsVC(nibName: "DetailsVC", bundle: nil)
    guard let movieId = movie.id else { return }
    nextVC.viewModel.loadMovie(movieId: String(movieId))
    nextVC.viewModel.loadCast(String(movieId))
    nextVC.viewModel.loadReviews(String(movieId))
    
    configureItems(nextVC)
    navigationController?.pushViewController(nextVC, animated: true)
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
  
}

//MARK: -UITableViewDelegate
extension MainMenuVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.cellName) as? MenuTableViewCell else {return UITableViewCell()}
    cell.setup(category: viewModel.dataForIndexPath(indexPath))
    cell.delegate = self
    cell.viewModel.genresDictionary = viewModel.genresDictionary
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height / 3
  }
  
}

extension MainMenuVC: UISearchBarDelegate {
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    tabBarController?.selectedIndex = 1
    return false
  }
  
}

