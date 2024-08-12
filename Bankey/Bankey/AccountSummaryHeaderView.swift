//
//  AccountSummaryHeaderView.swift
//  Bankey
//
//  Created by Леонид Турко on 12.08.2024.
//

import UIKit

class AccountSummaryHeaderView: UIView {
  @IBOutlet var contentView: UIView!
  
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
  }
}
