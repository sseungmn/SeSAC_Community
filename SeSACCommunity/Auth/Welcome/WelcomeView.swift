//
//  SignUpView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/01.
//

import UIKit

final class WelcomeView: BaseView {
    
    // MARK: Private Variable
    private var titleVStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
    }
    private var logoImageView = UIImageView().then { imageView in
        imageView.image = UIImage(named: "logo_ssac_clear")!
    }
    private var titleLabel = UILabel().then { label in
        label.text = "새싹 근처의 당근농장"
        label.font = .systemFont(ofSize: titleSize, weight: .heavy)
    }
    private var subtitleLabel = UILabel().then { label in
        label.text = "iOS 지식부터 바람의 나라까지\n지금 SeSAC에서 함께해보세요!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: subtitleSize, weight: .bold)
        label.textColor = .darkGray
    }
    
    // MARK: Accessable Variable
    var startButton = ConfirmButton().then { button in
        button.setTitle("시작하기", for: .normal)
    }
    var fotterLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        configureLabel()
    }
    
    // MARK: Set Constraint
    override func setConstraint() {
        addSubview(titleVStackView)
        titleVStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        titleVStackView.addArrangedSubview(logoImageView)
        titleVStackView.addArrangedSubview(titleLabel)
        titleVStackView.addArrangedSubview(subtitleLabel)
        
        addSubview(fotterLabel)
        fotterLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(fotterLabel.snp.top)
            make.height.equalTo(50)
        }
    }
    
    // MARK: Footer Label
    func configureLabel() {
        let login = "로그인"
        let generalText = String(format: "이미 계정이 있나요? %@", login)
        
        let lightGray = UIColor.lightGray
        let themeColor = UIColor.themeColor
        
        let generalFont = UIFont.systemFont(ofSize: SignUpView.textSize)
        let linkFont = UIFont.systemFont(ofSize: SignUpView.textSize, weight: .bold)
        
        let generalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: lightGray,
            .font: generalFont
        ]
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: themeColor,
            .font: linkFont
        ]
        
        let mutableString = NSMutableAttributedString()
        
        mutableString.append(
            NSAttributedString(string: generalText, attributes: generalAttributes)
        )
        
        mutableString.setAttributes(
            linkAttributes,
            range: (generalText as NSString).range(of: login)
        )
        fotterLabel.attributedText = mutableString
        fotterLabel.isUserInteractionEnabled = true
    }
    
}
