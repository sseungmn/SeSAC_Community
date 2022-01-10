//
//  ViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import UIKit

class SignInViewController: BaseViewController, UINavigationMemeber {
    
    let mainView = SignInView()
    
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
        mainView.passwordTextFeild.text = UserInfo.password
    }
    
    override func subscribe() {
        mainView.confirmButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self,
                      let username = self.mainView.usernameTextField.text,
                      let password = self.mainView.passwordTextFeild.text else { return }
                
                APIService.requestSignIn(username: username, password: password) { userData, error in
                    guard error == nil else {
                        print("로그인 실패", error!)
                        return
                    }
                    guard let userData = userData else { return }
                    UserInfo.jwt = userData.jwt
                    UserInfo.id = userData.user.id
                    UserInfo.username = username
                    UserInfo.password = password
                    DispatchQueue.main.async {
                        self.changeRootVC(to: BoardViewController())
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
}
