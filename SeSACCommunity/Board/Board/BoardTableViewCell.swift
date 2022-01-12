//
//  PostView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/03.
//

import UIKit

import RxSwift

class BoardTableViewCell: BaseCell {
    
    let contentStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    let postStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    let bodyLabel = UILabel().then { label in
        label.numberOfLines = 4
    }
    let infoStackHView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }
    let userNameLabel = UILabel().then { label in
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
    }
    let dateLabel = UILabel().then { label in
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
    }
    
    let defaultSeparator = SeparatorView(of: .default)
    
    let commentInfoStackView = CommentInfoStackView()
    
    let thickSeparator = SeparatorView(of: .thick)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        defaultSeparator.setFrame(from: postStackView.frame)
        thickSeparator.setFrame(from: rect)
    }
    
    override func configure() {
        commentInfoStackView.descriptionLabel.text = "댓글쓰기"
        selectionStyle = .none
    }
    
    override func setConstraint() {
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // Post
        contentStackView.addArrangedSubview(postStackView)
        postStackView.addArrangedSubview(bodyLabel)
        // Post - Info
        postStackView.addArrangedSubview(infoStackHView)
        infoStackHView.addArrangedSubview(userNameLabel)
        infoStackHView.addArrangedSubview(dateLabel)
        
        addSubview(defaultSeparator)
        
        // Comment
        contentStackView.addArrangedSubview(commentInfoStackView)
        
        addSubview(thickSeparator)
    }
    
    override func fetchInfo<T>(cellInfo: T) {
        guard let cellInfo = cellInfo as? Post else { return }
        bodyLabel.text = cellInfo.text
        userNameLabel.text = cellInfo.user.username
        dateLabel.text = cellInfo.updatedAt.toDate.toRelativeTodayTime
        switch cellInfo.comments.count {
        case 0:
            commentInfoStackView.descriptionLabel.text = "댓글 쓰기"
        default:
            commentInfoStackView.descriptionLabel.text = "댓글 \(cellInfo.comments.count)"
        }
    }
}
