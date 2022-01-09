//
//  CustomView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/07.
//

import UIKit

// MARK: Separator View
final class SeparatorView: UIView {
    private var height: CGFloat = 0
    
    enum SeparatorType {
        case `default`, thick
    }
    
    convenience init(of type: SeparatorType) {
        self.init(frame: .zero)
        switch type {
        case .default: self.height = 1.0
        case .thick: self.height = 8.0
        }
    }
    
    func setFrame(from targetFrame: CGRect) {
        var frame = targetFrame
        frame = CGRect(x: frame.origin.x,
                       y: frame.origin.y + frame.size.height - height,
                       width: frame.size.width,
                       height: height)
        self.frame = frame
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: CommentInfoStackView
final class CommentInfoStackView: UIStackView {
    
    let iconImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "bubble.right")!
        imageView.tintColor = .lightGray
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    let descriptionLabel = UILabel().then { label in
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        axis = .horizontal
        distribution = .fill
        spacing = 10.0
        layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        isLayoutMarginsRelativeArrangement = true
        
        addArrangedSubview(iconImageView)
        addArrangedSubview(descriptionLabel)
    }
}
