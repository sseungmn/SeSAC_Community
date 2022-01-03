//
//  ViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class WelcomeViewController: UIViewController {
  
  let mainView = WelcomeView()
  let disposeBag = DisposeBag()

  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backButton
    subscribe()
  }
  
  func subscribe() {
    mainView.startButton.rx
      .tap
      .subscribe { [weak self] _ in
        self?.makeRootViewController(SignUpViewController())
      }
      .disposed(by: disposeBag)
    mainView.fotterLabel.rx
      .tapGesture()
      .when(.recognized)
      .subscribe { [weak self] gesture in
        guard let self = self,
              let text = self.mainView.fotterLabel.text,
              let gesture = gesture.element else { return }
        let loginRange = (text as NSString).range(of: "로그인")
       
        if gesture.didTapAttributedTextInLabel(label: self.mainView.fotterLabel, inRange: loginRange) {
          self.makeRootViewController(SignInViewController())
        }
      }
      .disposed(by: disposeBag)
  }
}
