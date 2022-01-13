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
    let commentInfoStackView = CommentInfoStackView()
    
    private let separator3 = SeparatorView(of: .default)
    
    // MARK: Comment
    let commentTableView = CommentTableView()
    
    private let separator4 = SeparatorView(of: .default)
    
    let commentTextField = InsetTextField().then { textField in
        textField.placeholder = "댓글을 입력해주세요"
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .systemGray5
        textField.tintColor = .black
    }
    let commentSaveButton = RoundButton(size: 30).then { button in
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        contentStackView.addArrangedSubview(separator4)
        
        addSubview(commentTextField)
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
        addSubview(commentSaveButton)
        commentSaveButton.snp.makeConstraints { make in
            make.centerY.equalTo(commentTextField)
            make.right.equalTo(commentTextField).inset(10)
        }
    }
    
    func drawSeparator() {
        separator1.setFrame(from: postInfoHStackView.frame)
        separator2.setFrame(from: postStackView.frame)
        separator3.setFrame(from: commentInfoStackView.frame)
        separator4.setFrame(from: commentTableView.frame)
    }
    
    func fetchInfo<T>(info: T) {
        guard let info = info as? Post else { return }
        usernameLabel.text = info.user.username
        dateLabel.text = info.createdAt.toDate.toAbsoluteTime
        postBodyLabel.text = info.text
        commentInfoStackView.descriptionLabel.text = "댓글 \(info.comments.count)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.drawSeparator()
        }
    }
}
