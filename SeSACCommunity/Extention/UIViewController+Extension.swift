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
        let nav = UINavigationController(rootViewController: vc)
        drawSeparator(on: nav, isFrame: false)
        windowScene.windows.first?.rootViewController = nav
        windowScene.windows.first?.makeKeyAndVisible()
    }
    
    func pushVC(of vc: UIViewController) {
        guard let nav = self.navigationController else { return }
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        drawSeparator(on: nav, isFrame: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentVC(of vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        drawSeparator(on: nav, isFrame: true)
        self.present(nav, animated: true, completion: nil)
    }
    
    func drawSeparator(on nav: UINavigationController, isFrame: Bool) {
        let separator = SeparatorView(of: .default)
        nav.navigationBar.addSubview(separator)
        if isFrame {
            separator.setFrame(from: nav.navigationBar.frame)
        } else {
            separator.setFrame(from: nav.navigationBar.bounds)
        }
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
