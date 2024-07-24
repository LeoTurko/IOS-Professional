//
//  SceneDelegate.swift
//  Bankey
//
//  Created by Леонид Турко on 17.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  let loginViewController = LoginViewController()
  let onboardingViewController = OnboardingContainerViewController()
  let dummyViewController = DummyViewController()

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: scene)
    window?.makeKeyAndVisible()
    
    loginViewController.delegate = self
    onboardingViewController.delegate = self
    dummyViewController.logoutDelegate = self
    
    window?.rootViewController = loginViewController
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
    if LocalState.hasOnboarded {
      setRootViewController(dummyViewController)
    } else {
      setRootViewController(onboardingViewController)
    }
  }
}

extension SceneDelegate: OnboardingContainerViewControllerDelegate {
  func didFinishOnboarding() {
    LocalState.hasOnboarded = true
    setRootViewController(dummyViewController)
  }
}

extension SceneDelegate: LogoutDelegate {
  func didLogout() {
    setRootViewController(loginViewController)
  }
}
