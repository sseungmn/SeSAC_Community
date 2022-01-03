//
//  PostView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/03.
//

import UIKit

class BoardViewCell: UITableViewCell {
    let contentStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
    }
    let bodyLabel = UILabel().then { label in
        label.numberOfLines = 4
    }
    let infoStackView = UIStackView().then { stackView in
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
    let separatorView = SeparatorView(of: .thick)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraint()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        separatorView.setFrame(from: rect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
    }
    
    func setConstraint() {
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        contentStackView.addArrangedSubview(bodyLabel)
        contentStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(userNameLabel)
        infoStackView.addArrangedSubview(dateLabel)
        addSubview(separatorView)
    }
}
