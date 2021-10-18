//
//  HeaderView.swift
//  Final Project
//
//  Created by Andrey on 5.09.21.
//

import UIKit

class HeaderView: UIView {

    func setup(labelText: String){
        
        self.backgroundColor = .systemGray6
        
        let label = UILabel()
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let button = UIButton(frame: .zero)
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        //MARK: - Constraints
        label.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 15).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        button.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 15).isActive = true
        button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
    }
    
    

}
