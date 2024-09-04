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
  
  // Animation
  var leadingEdgeOnScreen: CGFloat = 16
  var leadingEdgeOffScreen: CGFloat = -1000
  
  var titleLeadingAnchor: NSLayoutConstraint?
  var subtitleLeadingAnchor: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    style()
    layout()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    signInButton.configuration?.showsActivityIndicator = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animate()
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
    titleLabel.alpha = 0
    
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.textAlignment = .center
    subtitleLabel.font = .preferredFont(forTextStyle: .title3)
    subtitleLabel.adjustsFontForContentSizeCategory = true
    subtitleLabel.numberOfLines = 0
    subtitleLabel.text = "Your premium source for all things banking!"
    subtitleLabel.alpha = 0
    
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
    
    titleLeadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
    titleLeadingAnchor?.isActive = true
    
    subtitleLeadingAnchor = subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
    subtitleLeadingAnchor?.isActive = true
    
    NSLayoutConstraint.activate([
      // Title
      subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
      titleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
      
      // Subtitle
      loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 3),
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

// MARK: - Animations
extension LoginViewController {
  private func animate() {
    let duration = 2.0
    let animator1 = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
      self.titleLeadingAnchor?.constant = self.leadingEdgeOnScreen
      self.view.layoutIfNeeded()
    }
    
    let animator2 = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
      self.subtitleLeadingAnchor?.constant = self.leadingEdgeOnScreen
      self.view.layoutIfNeeded()
    }
    
    let animator3 = UIViewPropertyAnimator(duration: duration * 2, curve: .easeInOut) {
      self.titleLabel.alpha = 1
      self.subtitleLabel.alpha = 1
      self.view.layoutIfNeeded()
    }
    
    animator1.startAnimation()
    animator2.startAnimation(afterDelay: 1)
    animator3.startAnimation(afterDelay: 1)
  }
}
