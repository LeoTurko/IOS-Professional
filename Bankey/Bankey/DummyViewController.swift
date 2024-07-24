//
//  DummyViewController.swift
//  Bankey
//
//  Created by Леонид Турко on 23.07.2024.
//

import UIKit

class DummyViewController: UIViewController {
  
  let stackView = UIStackView()
  let label = UILabel()
  let logoutButton = UIButton(type: .system)
  
  weak var logoutDelegate: LogoutDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    style()
    layout()
  }
}

extension DummyViewController {
  func style() {
    view.backgroundColor = .white
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 20
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Dummy"
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    
    logoutButton.translatesAutoresizingMaskIntoConstraints = false
    logoutButton.configuration = .filled()
    logoutButton.setTitle("Logout", for: .normal)
    logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .primaryActionTriggered)
  }
  
  func layout() {
    stackView.addArrangedSubview(label)
    stackView.addArrangedSubview(logoutButton)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
  
  @objc func logoutButtonTapped(sender: UIButton) {
    logoutDelegate?.didLogout()
  }
}
