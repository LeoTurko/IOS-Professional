//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Леонид Турко on 08.08.2024.
//

import UIKit

class AccountSummaryViewController: UIViewController {
  
  var accounts: [AccountSummaryCell.ViewModel] = []
  
  let tableView = UITableView()
  
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
  }
  
  private func setupTableView() {
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
    let header = AccountSummaryHeaderView(frame: .zero)
    
    var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    size.width = UIScreen.main.bounds.width
    header.frame.size = size
    
    tableView.tableHeaderView = header
  }
}

// MARK: - UITableViewDataSource
extension AccountSummaryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    accounts.count
  }
  
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as? AccountSummaryCell,
          !accounts.isEmpty else { return UITableViewCell() }
    
    let account = accounts[indexPath.row]
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
  private func fetchData() {
   fetchAccounts()
  }
  
  private func fetchAccounts() {
    let savings = AccountSummaryCell.ViewModel(accountType: .Banking,
                                                        accountName: "Basic Savings",
                                                    balance: 929466.23)
    let chequing = AccountSummaryCell.ViewModel(accountType: .Banking,
                                                accountName: "No-Fee All-In Chequing",
                                                balance: 17562.44)
    let visa = AccountSummaryCell.ViewModel(accountType: .CreditCard,
                                                   accountName: "Visa Avion Card",
                                                   balance: 412.83)
    let masterCard = AccountSummaryCell.ViewModel(accountType: .CreditCard,
                                                   accountName: "Student Mastercard",
                                                   balance: 50.83)
    let investment1 = AccountSummaryCell.ViewModel(accountType: .Investment,
                                                   accountName: "Tax-Free Saver",
                                                   balance: 2000.00)
    let investment2 = AccountSummaryCell.ViewModel(accountType: .Investment,
                                                   accountName: "Growth Fund",
                                                   balance: 15000.00)
    
    accounts.append(savings)
    accounts.append(chequing)
    accounts.append(visa)
    accounts.append(masterCard)
    accounts.append(investment1)
    accounts.append(investment2)
  }
}
