//
//  DetailPostView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/04.
//

import UIKit

final class DetailPostView: BaseView {
    // MARK: - Variable
    let scrollView = UIScrollView()
    
    let contentStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
    }
    
    let postStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    // MARK: PostInfo
    let postInfoHStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    let postInfoVStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
    }
    let userImageView = UIImageView().then { imageView in
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
    
    let separator1 = SeparatorView(of: .default)
    
    // MARK: Post Body
    let postBodyStackView = UIStackView().then { stackView in
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    let postBodyLabel = UILabel().then { label in
        label.numberOfLines = 0
    }
    
    let separator2 = SeparatorView(of: .default)
    
    // MARK: CommentInfo
    let commentHStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10.0
        
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    let commentImageView = UIImageView().then { imageView in
        guard let image = UIImage(systemName: "bubble.right") else { return }
        imageView.image = image
        imageView.tintColor = .lightGray
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    let commentDescriptionLabel = UILabel().then { label in
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15)
    }
    
    let separator3 = SeparatorView(of: .default)
    
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
        postBodyLabel.text = "코로나로 인해서 일자리도 많이 줄고 취업하기도 어렵구 씁쓸하네요오"
        commentDescriptionLabel.text = "댓글 4"
    }
    
    override func setConstraint() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        
        scrollView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.left.right.width.equalToSuperview()
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
        
        scrollView.addSubview(separator1)
        
        postStackView.addArrangedSubview(postBodyStackView)
        postBodyStackView.addArrangedSubview(postBodyLabel)
        
        scrollView.addSubview(separator2)
        
        // MARK: CommentInfo
        contentStackView.addArrangedSubview(commentHStackView)
        commentHStackView.addArrangedSubview(commentImageView)
        commentHStackView.addArrangedSubview(commentDescriptionLabel)
        
        scrollView.addSubview(separator3)
    }
    
    // MARK: Set Separator
    override func draw(_ rect: CGRect) {
        separator1.setFrame(from: postInfoHStackView.frame)
        separator2.setFrame(from: postStackView.frame)
        separator3.setFrame(from: commentHStackView.frame)
    }
}
