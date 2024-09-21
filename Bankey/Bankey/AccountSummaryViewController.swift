//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Леонид Турко on 08.08.2024.
//

import UIKit

class AccountSummaryViewController: UIViewController {
  
  // Request Models
  var profile: Profile?
  var accounts: [Account] = []
  
  // View Models
  var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "", date: Date())
  var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
  
  let tableView = UITableView()
  let headerView = AccountSummaryHeaderView(frame: .zero)
  
  lazy var logoutBarButtonItem: UIBarButtonItem = {
    let element = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
    element.tintColor = .label
    return element
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    fetchData()
  }
}

extension AccountSummaryViewController {
  private func setup() {
    view.backgroundColor = .white
    setupTableView()
    setupTableHeaderView()
    setupNavigationBar()
  }
  
  private func setupTableView() {
    tableView.backgroundColor = appColor
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
    tableView.rowHeight = AccountSummaryCell.rowHeight
    tableView.tableFooterView = UIView()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  private func setupTableHeaderView() {
    let headerView = AccountSummaryHeaderView(frame: .zero)
    
    var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    size.width = UIScreen.main.bounds.width
    headerView.frame.size = size
    
    tableView.tableHeaderView = headerView
  }
  
  func setupNavigationBar() {
    navigationItem.rightBarButtonItem = logoutBarButtonItem
  }
}

// MARK: - UITableViewDataSource
extension AccountSummaryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    accountCellViewModels.count
  }
  
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as? AccountSummaryCell,
          !accountCellViewModels.isEmpty else { return UITableViewCell() }
    
    let account = accountCellViewModels[indexPath.row]
    cell.configure(with: account)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension AccountSummaryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

extension AccountSummaryViewController {
  @objc func logoutTapped(sender: UIButton) {
    NotificationCenter.default.post(name: .logout, object: nil)
  }
}

// MARK: - Networking
extension AccountSummaryViewController {
  private func fetchData() {
    let group = DispatchGroup()
    
    group.enter()
    fetchProfile(forUserId: "1") { result in
      switch result {
      case .success(let profile):
        self.profile = profile
        self.configureTableHeaderView(with: profile)
      case .failure(let error):
        print(error.localizedDescription)
      }
      group.leave()
    }
    
    group.enter()
    fetchAccounts(forUserId: "1") { result in
      switch result {
      case .success(let accounts):
        self.accounts = accounts
        self.configureTableCells(with: accounts)
      case .failure(let error):
        print(error.localizedDescription)
      }
      group.leave()
    }
    
    group.notify(queue: .main) {
      self.tableView.reloadData()
    }
  }
  
  private func configureTableHeaderView(with profile: Profile) {
    let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning", name: profile.firstName, date: Date())
    headerView.configure(viewModel: vm)
  }
  
  private func configureTableCells(with accounts: [Account]) {
    accountCellViewModels = accounts.map {
      AccountSummaryCell.ViewModel(
        accountType: $0.type,
        accountName: $0.name,
        balance: $0.amount
      )
    }
  }
}
