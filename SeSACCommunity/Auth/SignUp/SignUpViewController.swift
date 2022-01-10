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
                guard let username = self?.mainView.usernameTextFeild.text else { return }
                guard let email = self?.mainView.emailTextFeild.text else { return }
                guard let password = self?.mainView.passwordTextFeild.text else { return }
                APIService.requestSignUp(username: username, email: email, password: password) { userInfo, error in
                    guard error == nil else {
                        print("회원가입 오류", error!)
                        return
                    }
                    guard let userInfo = userInfo else { return }
                    UserInfo.jwt = userInfo.jwt
                    UserInfo.id = userInfo.user.id
                    UserInfo.username = username
                    UserInfo.password = password
                    
                    DispatchQueue.main.async {
                        self?.changeRootVC(to: BoardViewController())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        let emailValidation = mainView.emailTextFeild.rx.text
            .orEmpty
            .map { $0.isEmpty == false && $0.components(separatedBy: "@").filter { !$0.isEmpty }.count == 2 }
            .share(replay: 1, scope: .whileConnected)
        let usernameValidation = mainView.usernameTextFeild.rx.text
            .orEmpty
            .map { $0.isEmpty == false }
            .share(replay: 1, scope: .whileConnected)
        let passwordValidation = mainView.passwordTextFeild.rx.text
            .orEmpty
            .map { $0.isEmpty == false }
            .share(replay: 1, scope: .whileConnected)
        let passwordCheckValidation = mainView.passwordCheckTextFeild.rx.text
            .orEmpty
            .map { $0.isEmpty == false }
            .share(replay: 1, scope: .whileConnected)
        
        let passwordSame = Observable.combineLatest(
            mainView.passwordTextFeild.rx.text.orEmpty,
            mainView.passwordCheckTextFeild.rx.text.orEmpty) { origin, check in
                return origin == check
            }
            .share(replay: 1, scope: .whileConnected)
        
        let isValid = Observable.combineLatest(emailValidation, usernameValidation, passwordValidation, passwordCheckValidation, passwordSame) { $0 && $1 && $2 && $3 && $4 }
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
