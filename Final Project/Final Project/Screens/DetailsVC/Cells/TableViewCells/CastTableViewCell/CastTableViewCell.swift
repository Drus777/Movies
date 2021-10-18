//
//  CastTableViewCell.swift
//  Final Project
//
//  Created by Andrey on 30.09.21.
//

import UIKit

class CastTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var segmentControl: UISegmentedControl!
  
  static let cellName = "CastTableViewCell"
  
  var cast: [ActorInfo] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  
  var reviews: [Review] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.register(UINib(nibName: CastCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: CastCollectionViewCell.cellName)
    collectionView.register(UINib(nibName: ReviewsCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: ReviewsCollectionViewCell.cellName)
    setup()
  }
  
  @IBAction func didChangeSegment() {
    collectionView.reloadData()
  }
  
  func setupWithViewModel(_ cast: [ActorInfo], _ reviews: [Review]) {
    self.cast = cast
    self.reviews = reviews
  }
  
  private func setup(){
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension CastTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  //MARK: -UICollectionViewDelegate
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    switch segmentControl.selectedSegmentIndex {
    case 0:
      return cast.count
    case 1:
      return reviews.count
    default:
      break
    }
    
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch segmentControl.selectedSegmentIndex {
    case 0:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.cellName, for: indexPath) as? CastCollectionViewCell
      else {return UICollectionViewCell()}
      
      cell.setup(actorInfo: cast[indexPath.item])
      return cell
      
    case 1:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewsCollectionViewCell.cellName, for: indexPath) as? ReviewsCollectionViewCell
      else {return UICollectionViewCell()}
      
      cell.setup(reviews[indexPath.item])
      return cell
    default:
      break
    }
   
    return UICollectionViewCell()
  }
  
  //MARK: -UICollectionViewDelegateFlowLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    switch segmentControl.selectedSegmentIndex {
    case 0:
      return  CGSize(width: (UIScreen.main.bounds.width - 10) / 3, height: DetailsVC.tableViewRowHeight / 2)
    case 1:
      return  CGSize(width: UIScreen.main.bounds.width - 10, height: DetailsVC.tableViewRowHeight / 2)
    default:
      break
    }
    
    return CGSize(width: (UIScreen.main.bounds.width - 10) / 3, height: DetailsVC.tableViewRowHeight / 2)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
  }
  
}


