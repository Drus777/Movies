//
//  ProfileVC.swift
//  Final Project
//
//  Created by Andrey on 6.10.21.
//

import UIKit
import FirebaseStorage
import Firebase

class ProfileVC: UIViewController {
  
  @IBOutlet private weak var signInButton: UIButton!
  @IBOutlet private weak var logOutButton: UIButton!
  @IBOutlet private weak var changeButton: UIButton!
  @IBOutlet private weak var signInLastAccButton: UIButton!
  @IBOutlet private weak var profileImageView: UIImageView!
  @IBOutlet private weak var fullNameLabel: UILabel!
  @IBOutlet private weak var historyButton: UIButton!
  
  var viewModel: ProfileViewModelProtocol = ProfileViewModel()
  private let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupProfileImageView()
    handle()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func signButtonDidTapped() {
    let alert = UIAlertController(title: "Log into your account or sing up", message: "", preferredStyle: .actionSheet)
    
    let loginButton = UIAlertAction(title: "Sign in", style: .default) { [weak self] action in
      let nextVC = LoginVC(nibName: "LoginVC", bundle: nil)
      self?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    let signUpButton = UIAlertAction(title: "Sign up", style: .default) { [weak self] action in
      let nextVC = RegistrationVC(nibName: "RegistrationVC", bundle: nil)
      self?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] action in
      self?.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(loginButton)
    alert.addAction(signUpButton)
    alert.addAction(cancelButton)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func logOutButtonDidTapped() {
    let alert = UIAlertController(title: "Are you sure about it?", message: "", preferredStyle: .actionSheet)
    
    let yesButton = UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
      self?.logOutFromFirebase()
      self?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] action in
      self?.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(yesButton)
    alert.addAction(cancelButton)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func changeButtonDidTapped(){
    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func signInLastAccButtonDidTapped(){
    viewModel.singIn()
  }
  
  @IBAction func historyButtonDidTapped(){
    let nextVC = HistoryVC(nibName: "HistoryVC", bundle: nil)
    configureItems(nextVC)
    navigationController?.pushViewController(nextVC, animated: true)
  }
  
  private func logOutFromFirebase(){
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()

    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
  }
  
  // MARK: - NavigationBar
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
  
  private func setupProfileImageView() {
    profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    imagePicker.delegate = self
  }
  
  //MARK: - upload photo to firebase
  private func uploadUserPhoto() {
    
    let currentUser = Auth.auth().currentUser
    guard let user = currentUser else {return}
    
    viewModel.upload(userId: user.uid, photo: profileImageView) { result in
      switch result {
      case .success(let url):
        let db = Firestore.firestore()
        let documentRef = db.collection("users").document(user.uid)
        documentRef.updateData([
          "avatarURL": url.absoluteString
        ])
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  private func handle() {
    Auth.auth().addStateDidChangeListener { [weak self] auth, user in
      
      if user != nil {
        self?.viewModel.getProfileFromFirebase {
          self?.fullNameLabel.text = $0.fullname
          self?.profileImageView.downloadedFromFirebase(from: $0.avatarURL)
        }
        self?.changeButton.isHidden = false
        self?.logOutButton.isHidden = false
        self?.signInButton.isHidden = true
        self?.profileImageView.isHidden = false
        self?.fullNameLabel.isHidden = false
        self?.signInLastAccButton.isHidden = true
        self?.historyButton.isHidden = false
      } else {
        self?.changeButton.isHidden = true
        self?.signInButton.isHidden = false
        self?.profileImageView.isHidden = true
        self?.fullNameLabel.isHidden = true
        self?.logOutButton.isHidden = true
        self?.historyButton.isHidden = true
        self?.signInLastAccButton.isHidden = false
      }
    }
  }
}

extension ProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      profileImageView.image = image
      uploadUserPhoto()
    }
    picker.dismiss(animated: true, completion: nil)
  }
}
