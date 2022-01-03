//
//  ViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/01.
//

import UIKit
import RxGesture

class WelcomeViewController: BaseViewController {
    
    let mainView = WelcomeView()
    //  let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func subscribe() {
        // startButton(회원가입) -> SignUpView
        mainView.startButton.rx
            .tap
            .subscribe { [weak self] _ in
                self?.pushVC(of: SignUpViewController())
            }
            .disposed(by: disposeBag)
        // fotterLabel(로그인) -> SignInView
        mainView.fotterLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] gesture in
                guard let self = self,
                      let text = self.mainView.fotterLabel.text,
                      let gesture = gesture.element else { return }
                let loginRange = (text as NSString).range(of: "로그인")
                
                if gesture.didTapAttributedTextInLabel(label: self.mainView.fotterLabel, inRange: loginRange) {
                    self.pushVC(of: SignInViewController())
                }
            }
            .disposed(by: disposeBag)
    }
}
