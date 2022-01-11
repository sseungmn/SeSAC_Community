//
//  SignUpView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import UIKit

final class SignInView: BaseView {
    
    // MARK: Private Variable
    private  let fieldTitles = ["닉네임", "비밀번호"]
    private var VStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.spacing = 8
    }
    
    // MARK: Accesable Variable
    var usernameTextField = FormTextField()
    var passwordTextField = FormTextField().then { textField in
        textField.textContentType = .password
        textField.isSecureTextEntry = true
    }
    var confirmButton = ConfirmButton().then { button in
        button.setTitle("로그인", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        for (index, textField) in [usernameTextField, passwordTextField].enumerated() {
            textField.placeholder = fieldTitles[index]
        }
    }
    
    // MARK: Set Constraint
    override func setConstraint() {
        addSubview(VStackView)
        VStackView.addArrangedSubview(usernameTextField)
        VStackView.addArrangedSubview(passwordTextField)
        VStackView.addArrangedSubview(confirmButton)
        VStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
    }
}
