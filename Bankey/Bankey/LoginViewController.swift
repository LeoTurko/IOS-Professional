//
//  LoginViewController.swift
//  Bankey
//
//  Created by Леонид Турко on 17.05.2024.
//

import UIKit

protocol LogoutDelegate: AnyObject {
  func didLogout()
}

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

class LoginViewController: UIViewController {
  
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let loginView = LoginView()
  private let signInButton = UIButton(type: .system)
  private let errorMessageLabel = UILabel()
  
  weak var delegate: LoginViewControllerDelegate?
  
  var username: String? {
    return loginView.usernameTextField.text
  }
  
  var password: String? {
    return loginView.passwordTextField.text
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    style()
    layout()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    signInButton.configuration?.showsActivityIndicator = false
  }
}

// MARK: - Set Style and Layout
extension LoginViewController {
  private func style() {
    view.backgroundColor = .systemBackground
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = "Bankey"
    titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
    titleLabel.textAlignment = .center
    
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.textAlignment = .center
    subtitleLabel.font = .preferredFont(forTextStyle: .title3)
    subtitleLabel.adjustsFontForContentSizeCategory = true
    subtitleLabel.numberOfLines = 0
    subtitleLabel.text = "Your premium source for all things banking!"
    
    loginView.translatesAutoresizingMaskIntoConstraints = false
    
    signInButton.translatesAutoresizingMaskIntoConstraints = false
    signInButton.configuration = .filled()
    signInButton.configuration?.imagePadding = 8
    signInButton.setTitle("Sign in", for: [])
    signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)
    
    errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
    errorMessageLabel.textAlignment = .center
    errorMessageLabel.textColor = .systemRed
    errorMessageLabel.numberOfLines = 0
    errorMessageLabel.isHidden = true
    
  }
  
  private func layout() {
    view.addSubview(titleLabel)
    view.addSubview(subtitleLabel)
    view.addSubview(loginView)
    view.addSubview(signInButton)
    view.addSubview(errorMessageLabel)
    
    NSLayoutConstraint.activate([
      // Title
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
      
      // Subtitle
      loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 3),
      subtitleLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
      subtitleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
      
      // LoginView
      loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
      view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 2),
      
      // SignButton
      signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
      signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
      signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
      
      // Error Massage
      errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
      errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
      errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
    ])
  }
}

// MARK: - Actions
extension LoginViewController {
  @objc private func signInTapped(sender: UIButton) {
    errorMessageLabel.isHidden = true
    login()
  }
  
  private func login() {
    guard let username, let password else {
      assertionFailure("Username / password should never be nil")
      return
    }
    
    guard !username.isEmpty, !password.isEmpty else {
      configureView(withMessage: "Username / password connot be blank")
      return
    }
    
    guard username == "Leo" && password == "Turko" else {
      configureView(withMessage: "Incorrect username / password")
      return
    }
    
    signInButton.configuration?.showsActivityIndicator = true
    delegate?.didLogin()
  }
  
  private func configureView(withMessage message: String) {
    errorMessageLabel.isHidden = false
    errorMessageLabel.text = message
  }
}
