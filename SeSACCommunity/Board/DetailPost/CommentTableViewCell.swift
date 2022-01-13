//
//  CommentTableViewCell.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/05.
//

import UIKit

class CommentTableViewCell: BaseCell {
    
    private let VstackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    private let HstackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }
    let usernameLabel = UILabel().then { label in
        label.font = .systemFont(ofSize: 13, weight: .heavy)
        label.textAlignment = .left
    }
    let moreActionButton = UIButton().then { button in
        let image = UIImage(named: "ellipsis.vertical")!
        button.setImage(image, for: .normal)
    }
    let commentLabel = UILabel().then { label in
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 0
    }
    
    override func setConstraint() {
        contentView.addSubview(VstackView)
        VstackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        VstackView.addArrangedSubview(HstackView)
        HstackView.addArrangedSubview(usernameLabel)
        HstackView.addArrangedSubview(moreActionButton)
        
        VstackView.addArrangedSubview(commentLabel)
    }
    
    override func fetchInfo<T>(cellInfo: T) {
        guard let cellInfo = cellInfo as? Comment else { return }
        
        backgroundColor = .randomColor
        if cellInfo.user.id != UserInfo.id {
            moreActionButton.isHidden = true
        } else {
            moreActionButton.isHidden = false
        }
        usernameLabel.text = cellInfo.user.username
        commentLabel.text = cellInfo.comment
    }
}
