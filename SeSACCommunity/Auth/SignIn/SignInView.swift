//
//  SignUpView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import UIKit

class SignInView: BaseView {
    
    // MARK: Private Variable
    private  let fieldTitles = ["닉네임", "비밀번호"]
    private var VStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.spacing = 8
    }
    
    // MARK: Accesable Variable
    var nickNameTextFeild = CustomTextField()
    var passwordTextFeild = CustomTextField()
    var confirmButton = CustomButton().then { button in
        button.setTitle("로그인", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        for (index, textField) in [nickNameTextFeild, passwordTextFeild].enumerated() {
            textField.placeholder = fieldTitles[index]
        }
    }
    
    // MARK: Set Constraint
    override func setConstraint() {
        addSubview(VStackView)
        VStackView.addArrangedSubview(nickNameTextFeild)
        VStackView.addArrangedSubview(passwordTextFeild)
        VStackView.addArrangedSubview(confirmButton)
        VStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
    }
}
