//
//  HeaderView.swift
//  Final Project
//
//  Created by Andrey on 28.09.21.
//

import UIKit

final class HeaderView: UIView {
  
  private var imageViewHeight = NSLayoutConstraint()
  private var imageViewBottom = NSLayoutConstraint()
  let imageView = UIImageView()

  init() {
    super.init(frame: CGRect.zero)
    self.addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    imageViewHeight = imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
    imageViewHeight.isActive = true
    imageViewBottom = imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    imageViewBottom.isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(url: String) {
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleToFill
    imageView.downloaded(from: url)
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    imageViewHeight.constant = scrollView.contentInset.top
    let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
    self.clipsToBounds = offsetY <= 0
    imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
    imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
  }
  
}

