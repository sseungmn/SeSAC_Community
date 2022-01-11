//
//  ViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import UIKit
import RxRelay
import RxCocoa

class SignInViewController: BaseViewController, UINavigationMemeber {
    
    let mainView = SignInView()
    
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "새싹농장 가입하기"
    }
    
    override func setConstraint() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalToSuperview()
            make.height.equalTo(162)
        }
    }
    
    override func configure() {
        mainView.usernameTextField.text = UserInfo.username
        mainView.passwordTextField.text = UserInfo.password
    }
    
    override func subscribe() {
        viewModel.result
            .subscribe(
                onNext: { _ in
                    self.pushVC(of: BoardViewController())
                }, onError: { error in
                    print(error)
                })
            .disposed(by: disposeBag)
        
        self.mainView.usernameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.usernameChanged)
            .disposed(by: disposeBag)
        
        self.mainView.passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordChanged)
            .disposed(by: disposeBag)
        
        self.mainView.confirmButton.rx.tap
            .bind(to: viewModel.confirmButtonTap)
            .disposed(by: disposeBag)
    }
    
}
