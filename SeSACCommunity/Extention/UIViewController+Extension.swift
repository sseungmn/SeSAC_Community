//
//  UIViewController+Extension.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/03.
//

import UIKit

extension UIViewController {
  func changeRootVC(to vc: UIViewController) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
    windowScene.windows.first?.makeKeyAndVisible()
  }
  
  func pushVC(of vc: UIViewController) {
    let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backButton
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}

protocol UINavigationMemeber: UIViewController {
  var navigationTitle: String { get set }
}

extension UINavigationMemeber {
  var navigationTitle: String {
    get {
      guard let title = self.navigationItem.title else { return "" }
      return title
    }
    set(newTitle) {
      self.navigationItem.title = newTitle
    }
  }
}
