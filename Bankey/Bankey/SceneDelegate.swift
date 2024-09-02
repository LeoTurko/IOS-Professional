//
//  SceneDelegate.swift
//  Bankey
//
//  Created by Леонид Турко on 17.05.2024.
//

import UIKit

let appColor: UIColor = .systemTeal

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  let loginViewController = LoginViewController()
  let onboardingViewController = OnboardingContainerViewController()
  let mainViewCotroller = MainViewController()

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: scene)
    window?.makeKeyAndVisible()
    window?.backgroundColor = .systemBackground
    
    loginViewController.delegate = self
    onboardingViewController.delegate = self
    
    registerForNotifications()
    
    displayLogin()
  }
  
  private func registerForNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .logout, object: nil)
  }
}

extension SceneDelegate {
  private func displayLogin() {
    setRootViewController(loginViewController)
  }
  
  private func displayNextScreen() {
    if LocalState.hasOnboarded {
      prepMainView()
      setRootViewController(mainViewCotroller)
    } else {
      setRootViewController(onboardingViewController)
    }
  }
  
  private func prepMainView() {
    mainViewCotroller.setStatusBar()
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().backgroundColor = appColor
  }
}

extension SceneDelegate {
  func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
    guard animated, let window else {
      self.window?.rootViewController = vc
      self.window?.makeKeyAndVisible()
      return
    }
    
    window.rootViewController = vc
    window.makeKeyAndVisible()
    UIView.transition(
      with: window,
      duration: 0.7,
      options: .transitionCrossDissolve,
      animations: nil
    )
  }
}

extension SceneDelegate: LoginViewControllerDelegate {
  func didLogin() {
    displayNextScreen()
  }
}

extension SceneDelegate: OnboardingContainerViewControllerDelegate {
  func didFinishOnboarding() {
    LocalState.hasOnboarded = true
    prepMainView()
    setRootViewController(mainViewCotroller)
  }
}

extension SceneDelegate: LogoutDelegate {
  @objc func didLogout() {
    setRootViewController(loginViewController)
  }
}
