//
//  ViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import UIKit

import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController, UINavigationMemeber {
    
    let mainView = SignUpView()
    
    let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "새싹농장 가입하기"
    }
    
    override func setConstraint() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalToSuperview()
            make.height.equalTo(274)
        }
        
    }
    
    override func subscribe() {
        let input = SignUpViewModel.Input(
            email: mainView.emailTextFeild.rx.text.orEmpty,
            username: mainView.usernameTextFeild.rx.text.orEmpty,
            password: mainView.passwordTextFeild.rx.text.orEmpty,
            passwordCheck: mainView.passwordCheckTextFeild.rx.text.orEmpty,
            confirmButtonTap: mainView.confirmButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValid
            .bind(to: mainView.confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isValid
            .map { $0 ? UIColor.themeColor : UIColor.lightGray }
            .bind(to: mainView.confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        output.result
            .subscribe { _ in
                self.changeRootVC(to: BoardViewController())
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)

    }
}
