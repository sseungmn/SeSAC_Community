//
//  SignUpView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import UIKit

final class SignUpView: BaseView {
    
    // MARK: Private Variable
    private let fieldTitles = ["이메일 주소", "닉네임", "비밀번호", "비밀번호 확인"]
    private var VStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.spacing = 8
    }
    
    // MARK: Accessable Variable
    var emailTextFeild = FormTextField()
    var usernameTextFeild = FormTextField()
    var passwordTextFeild = FormTextField().then { textField in
        textField.isSecureTextEntry = true
    }
    var passwordCheckTextFeild = FormTextField().then { textField in
        textField.isSecureTextEntry = true
    }
    var confirmButton = ConfirmButton().then { button in
        button.setTitle("가입하기", for: .disabled)
        button.setTitle("시작하기", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        for (index, textField) in [emailTextFeild, usernameTextFeild, passwordTextFeild, passwordCheckTextFeild].enumerated() {
            textField.placeholder = fieldTitles[index]
        }
    }
    
    // MAKR: Set Constraint
    override func setConstraint() {
        addSubview(VStackView)
        VStackView.addArrangedSubview(emailTextFeild)
        VStackView.addArrangedSubview(usernameTextFeild)
        VStackView.addArrangedSubview(passwordTextFeild)
        VStackView.addArrangedSubview(passwordCheckTextFeild)
        VStackView.addArrangedSubview(confirmButton)
        VStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
    }
}
