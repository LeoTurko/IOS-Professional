//
//  LoginView.swift
//  Bankey
//
//  Created by Леонид Турко on 21.05.2024.
//

import UIKit

class LoginView: UIView {
  
  let usernameTextField = UITextField()
  let passwordTextField = UITextField()
  let stackView = UIStackView()
  let dividerView = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension LoginView {
  func style() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .secondarySystemBackground
    layer.cornerRadius = 5
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 8
    
    usernameTextField.translatesAutoresizingMaskIntoConstraints = false
    usernameTextField.placeholder = "Username"
    usernameTextField.delegate = self
    
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    passwordTextField.placeholder = "Password"
    passwordTextField.isSecureTextEntry = true
    passwordTextField.delegate = self
    passwordTextField.enablePasswordToggle()
    
    dividerView.translatesAutoresizingMaskIntoConstraints = false
    dividerView.backgroundColor = .secondarySystemFill
  }
  
  func layout() {
    stackView.addArrangedSubview(usernameTextField)
    stackView.addArrangedSubview(dividerView)
    stackView.addArrangedSubview(passwordTextField)
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
      stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
      trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),
      bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1),
      
      dividerView.heightAnchor.constraint(equalToConstant: 2),
    ])
  }
}

// MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    usernameTextField.endEditing(true)
    passwordTextField.endEditing(true)
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    return true 
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
  }
}
