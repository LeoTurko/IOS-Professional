//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Леонид Турко on 08.08.2024.
//

import UIKit

class AccountSummaryViewController: UIViewController {
  
  let games = [
    "Pacman",
    "Space Invaders",
    "Space Patrol",
  ]
  
  let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}

extension AccountSummaryViewController {
  private func setup() {
    view.backgroundColor = .white
    setupTableView()
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}

extension AccountSummaryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    games.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = games[indexPath.row]
    return cell
  }
}

extension AccountSummaryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}
