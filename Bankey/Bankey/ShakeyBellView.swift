//
//  ShakeyBellView.swift
//  Bankey
//
//  Created by Леонид Турко on 06.09.2024.
//

import UIKit

class ShakeyBellView: UIView {
  
  private let imageView = UIImageView()
  private let buttonView = UIButton()
  
  private let buttonHeight: CGFloat = 16
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    setupUI()
    configureSubviews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: 48, height: 48)
  }
}

//  MARK: - Set Views and Constraints
private extension ShakeyBellView {
  func setupUI() {
    translatesAutoresizingMaskIntoConstraints = false
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "bell.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    imageView.image = image
    
    buttonView.translatesAutoresizingMaskIntoConstraints = false
    buttonView.backgroundColor = .systemRed
    buttonView.titleLabel?.font = .systemFont(ofSize: 13)
    buttonView.layer.cornerRadius = buttonHeight/2
    buttonView.setTitle("9", for: .normal)
    buttonView.setTitleColor(.white, for: .normal)
  }
  
  func configureSubviews() {
    addSubview(imageView)
    addSubview(buttonView)
  }
  
  func setupConstraints() {
    // ImageView
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 24),
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
    ])
    
    // Button View
    NSLayoutConstraint.activate([
      buttonView.topAnchor.constraint(equalTo: imageView.topAnchor),
      buttonView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -9),
      buttonView.widthAnchor.constraint(equalToConstant: 16),
      buttonView.heightAnchor.constraint(equalToConstant: 16)
    ])
  }
}

private extension ShakeyBellView {
  func setup() {
    let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
    imageView.addGestureRecognizer(singleTap)
    imageView.isUserInteractionEnabled = true
  }
  
  @objc func imageViewTapped(_ recognizer: UITapGestureRecognizer) {
    shakeWith(duration: 1, angle: .pi/8, yOffset: 0.0)
  }
  
  private func shakeWith(duration: Double, angle: CGFloat, yOffset: CGFloat) {
    let numberOfFrames = 6.0
    let frameDuration = 1/numberOfFrames
    
    imageView.setAnchorPoint(CGPoint(x: 0.5, y: yOffset))
    
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: [],
                            animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0,
                         relativeDuration: frameDuration) {
        self.imageView.transform = CGAffineTransform(rotationAngle: -angle)
      }
      UIView.addKeyframe(withRelativeStartTime: frameDuration,
                         relativeDuration: frameDuration) {
        self.imageView.transform = CGAffineTransform(rotationAngle: +angle)
      }
      UIView.addKeyframe(withRelativeStartTime: frameDuration*2,
                         relativeDuration: frameDuration) {
        self.imageView.transform = CGAffineTransform(rotationAngle: -angle)
      }
      UIView.addKeyframe(withRelativeStartTime: frameDuration*3,
                         relativeDuration: frameDuration) {
        self.imageView.transform = CGAffineTransform(rotationAngle: +angle)
      }
      UIView.addKeyframe(withRelativeStartTime: frameDuration*4,
                         relativeDuration: frameDuration) {
        self.imageView.transform = CGAffineTransform(rotationAngle: -angle)
      }
      UIView.addKeyframe(withRelativeStartTime: frameDuration*5,
                         relativeDuration: frameDuration) {
        self.imageView.transform = CGAffineTransform.identity
      }
    },
                            completion: nil
    )
  }
}

extension UIView {
  func setAnchorPoint(_ point: CGPoint) {
    var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
    var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
    
    newPoint = newPoint.applying(transform)
    oldPoint = oldPoint.applying(transform)
    
    var position = layer.position
    
    position.x -= oldPoint.x
    position.x += newPoint.x
    
    position.y -= oldPoint.y
    position.y += newPoint.y
    
    layer.position = position
    layer.anchorPoint = point
  }
}
