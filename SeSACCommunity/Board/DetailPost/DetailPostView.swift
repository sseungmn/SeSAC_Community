//
//  DetailPostView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/04.
//

import UIKit

final class DetailPostView: BaseView {
    // MARK: - Variable
    private let scrollView = UIScrollView()
    
    private let contentStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
    }
    
    private let postStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    // MARK: PostInfo
    private let postInfoHStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    private let postInfoVStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
    }
    private let userImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .lightGray
    }
    let usernameLabel = UILabel().then { label in
        label.font = .boldSystemFont(ofSize: 15)
    }
    let dateLabel = UILabel().then { label in
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
    }
    
    private let separator1 = SeparatorView(of: .default)
    
    // MARK: Post Body
    private let postBodyStackView = UIStackView().then { stackView in
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    let postBodyLabel = UILabel().then { label in
        label.numberOfLines = 0
    }
    
    private let separator2 = SeparatorView(of: .default)
    
    // MARK: CommentInfo
    private let commentInfoStackView = CommentInfoStackView()
    
    private let separator3 = SeparatorView(of: .default)
    
    // MARK: Comment
    let commentTableView = CommentTableView()
    
    private let separator4 = SeparatorView(of: .default)
    
    private let commentTextField = InsetTextField().then { textField in
        textField.placeholder = "댓글을 입력해주세요"
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .systemGray5
        textField.tintColor = .black
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func configure() {
        usernameLabel.text = "seouh"
        dateLabel.text = "01/04"
        postBodyLabel.text = """
만남은 쉽고 이별은 어려워
눈빛에 베일 듯 우린 날카로워
마침표를 찍고 난 조금 더 멀리 가려 해
만남은 쉽고 이별은 참 어려워
아직도 기억나 차 안의 공기가
처음 들었을 때 마음이 짜릿했던 뭔가가
6살이었지만 알았었지 뭔가 다르단 건
그렇게 쉽게 만나게 되는 거야 꿈이란 건
시간이 흘러서 이제 음악은 내 놀이가 됐고
듣고 따라만 부르기엔 내게는 뭔가 부족했어
그래서 실행에 옮겼지 방에서 혼자 꿈만 꾸던 모습
가사를 쓰고 부를 때 사실 내가 생각했던 건
돌아가야 할까 나아가야 할까
환호와 박수 소리를 들을 때 떠나야 할 것 같지 왜
지금 떠나서 아름다운 기억으로만 간직해
다들 꿈이란 건 이루지 못한 채 꾸고만 사는데
It's okay 괜찮아 난 맛이라도 봤잖아
다시 현실로 돌아가 그래 취직하고 잘 살아
잘 잊혀지고 있잖아
그런데 자꾸 왜 난 또 가사를 끄적이는 걸까 yeah
"""
        commentInfoStackView.descriptionLabel.text = "댓글 4"
    }
    
    override func setConstraint() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
        
        scrollView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // MARK: Post
        contentStackView.addArrangedSubview(postStackView)
        postStackView.addArrangedSubview(postInfoHStackView)
        userImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        postInfoHStackView.addArrangedSubview(userImageView)
        postInfoHStackView.addArrangedSubview(postInfoVStackView)
        
        postInfoVStackView.addArrangedSubview(usernameLabel)
        postInfoVStackView.addArrangedSubview(dateLabel)
        
        contentStackView.addSubview(separator1)
        
        postStackView.addArrangedSubview(postBodyStackView)
        postBodyStackView.addArrangedSubview(postBodyLabel)
        
        contentStackView.addSubview(separator2)
        
        // MARK: Comment
        contentStackView.addArrangedSubview(commentInfoStackView)
        
        contentStackView.addSubview(separator3)
        
        contentStackView.addArrangedSubview(commentTableView)
        
        addSubview(separator4)
        
        addSubview(commentTextField)
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    // MARK: Set Separator
    override func draw(_ rect: CGRect) {
        separator1.setFrame(from: postInfoHStackView.frame)
        separator2.setFrame(from: postStackView.frame)
        separator3.setFrame(from: commentInfoStackView.frame)
        separator4.setFrame(from: commentTableView.frame)
    }
}
