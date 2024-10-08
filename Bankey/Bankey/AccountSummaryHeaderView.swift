//
//  AccountSummaryHeaderView.swift
//  Bankey
//
//  Created by Леонид Турко on 12.08.2024.
//

import UIKit

class AccountSummaryHeaderView: UIView {
  @IBOutlet var contentView: UIView!
  
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  private let shakeyBellView = ShakeyBellView()
  
  struct ViewModel {
    let welcomeMessage: String
    let name: String
    let date: Date
    
    var dateFormatted: String {
      date.monthDayYearString
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    //commonInit()
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 144)
  }
  
  private func commonInit() {
    let bundle = Bundle(for: AccountSummaryHeaderView.self)
    bundle.loadNibNamed("AccountSummaryHeaderView", owner: self)
    addSubview(contentView)
    contentView.backgroundColor = appColor
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
    
    setupShakeyBell()
  }
  
  private func setupShakeyBell() {
    shakeyBellView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(shakeyBellView)
    
    NSLayoutConstraint.activate([
      shakeyBellView.trailingAnchor.constraint(equalTo: trailingAnchor),
      shakeyBellView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func configure(viewModel: ViewModel) {
    welcomeLabel.text = viewModel.welcomeMessage
    nameLabel.text = viewModel.name
    dateLabel.text = viewModel.dateFormatted
  }
}
