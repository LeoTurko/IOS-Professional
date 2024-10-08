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
  
  // Components
  let tableView = UITableView()
  let headerView = AccountSummaryHeaderView(frame: .zero)
  let refreshControll = UIRefreshControl()
  
  // Networking
  var profileManager: ProfileManagable = ProfileManager()
  
  lazy var errorAlert: UIAlertController = {
    let element = UIAlertController(title: "", message: "", preferredStyle: .alert)
    element.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return element
  }()
  
  var isLoaded = false
  
  lazy var logoutBarButtonItem: UIBarButtonItem = {
    let element = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
    element.tintColor = .label
    return element
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
  }
}

extension AccountSummaryViewController {
  private func setup() {
    view.backgroundColor = .white
    setupTableView()
    setupTableHeaderView()
    setupNavigationBar()
    setupRefreshControl()
    setupSkeletons()
    fetchData()
  }
  
  private func setupTableView() {
    tableView.backgroundColor = appColor
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
    tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
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
  
  private func setupRefreshControl() {
    refreshControll.tintColor = appColor
    refreshControll.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
    tableView.refreshControl = refreshControll
  }
  
  private func setupSkeletons() {
    let row = Account.makeSkeleton()
    accounts = Array(repeating: row, count: 10)
    
    configureTableCells(with: accounts)
  }
}

// MARK: - UITableViewDataSource
extension AccountSummaryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    accountCellViewModels.count
  }
  
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
    let account = accountCellViewModels[indexPath.row]
    
    if isLoaded {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as? AccountSummaryCell,
            !accountCellViewModels.isEmpty else { return UITableViewCell() }
      cell.configure(with: account)
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as? SkeletonCell else { return UITableViewCell() }
    return cell
  }
}

// MARK: - UITableViewDelegate
extension AccountSummaryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

// MARK: - Actions
extension AccountSummaryViewController {
  @objc func logoutTapped(sender: UIButton) {
    NotificationCenter.default.post(name: .logout, object: nil)
  }
  
  @objc func refreshContent() {
    reset()
    setupSkeletons()
    tableView.reloadData()
    fetchData()
  }
  
  private func reset() {
    profile = nil
    accounts = []
    isLoaded = false
  }
}

// MARK: - Networking
extension AccountSummaryViewController {
  private func fetchData() {
    let group = DispatchGroup()
    
    let userId = String(Int.random(in: 1..<4))
    
    fetchProfile(group: group, userId: userId)
    fetchAccounts(group: group, userId: userId)
    
    group.notify(queue: .main) {
      self.reloadView()
    }
  }
  
  private func fetchProfile(group: DispatchGroup, userId: String) {
    group.enter()
    
    profileManager.fetchProfile(forUserId: userId) { result in
      switch result {
      case .success(let profile):
        self.profile = profile
      case .failure(let error):
        self.displayError(error)
      }
      group.leave()
    }
  }
  
  private func fetchAccounts(group: DispatchGroup, userId: String) {
    group.enter()
    fetchAccounts(forUserId: userId) { result in
      switch result {
      case .success(let accounts):
        self.accounts = accounts
      case .failure(let error):
        self.displayError(error)
      }
      group.leave()
    }
  }
  
  private func reloadView() {
    self.tableView.refreshControl?.endRefreshing()
    
    guard let profile = self.profile else { return }
    
    self.isLoaded = true
    self.configureTableHeaderView(with: profile)
    self.configureTableCells(with: accounts)
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
  
  private func displayError(_ error: NetworkError) {
    let titleAndMessage = titleAndMessage(for: error)
    self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
  }
  
  private func titleAndMessage(for error: NetworkError) -> (String, String) {
    let title: String
    let message: String
    switch error {
    case .serverError:
      title = "Server Error"
      message = "We could not process your request. Please try again."
    case .decodingError:
      title = "Network Error"
      message = "Ensure you are connected to the internet. Please try again."
    }
    return (title, message)
  }
  
  private func showErrorAlert(title: String, message: String) {
    errorAlert.title = title
    errorAlert.message = message
    present(errorAlert, animated: true)
  }
}

extension AccountSummaryViewController {
  func titleAndMessageForTesting(for error: NetworkError) -> (String, String) {
    return titleAndMessage(for: error)
  }
  
  func forceFetchProfile() {
    fetchProfile(group: DispatchGroup(), userId: "1")
  }
}
