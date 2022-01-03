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
    let completedFormCount = BehaviorSubject<Int>(value: 0)
    
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
        mainView.confirmButton.rx.tap
            .subscribe { [weak self] _ in
                print("SignUp")
            }
            .disposed(by: disposeBag)
        
        let emailValidation = mainView.emailTextFeild
            .rx.text
            .map { ($0?.isEmpty)! == false }
            .share(replay: 1, scope: .whileConnected)
        let nicknameValidation = mainView.nickNameTextFeild
            .rx.text
            .map { ($0?.isEmpty)! == false }
            .share(replay: 1, scope: .whileConnected)
        let passwordValidation = mainView.passwordTextFeild
            .rx.text
            .map { ($0?.isEmpty)! == false }
            .share(replay: 1, scope: .whileConnected)
        let passwordCheckValidation = mainView.passwordCheckTextFeild
            .rx.text
            .map { ($0?.isEmpty)! == false }
            .share(replay: 1, scope: .whileConnected)
        
        let isValid = Observable.combineLatest(emailValidation, nicknameValidation, passwordValidation, passwordCheckValidation) { $0 && $1 && $2 && $3 }
            .share(replay: 1, scope: .whileConnected)
        
        isValid
            .bind(to: mainView.confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isValid
            .map { $0 ? UIColor.themeColor : UIColor.lightGray}
            .bind(to: mainView.confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
