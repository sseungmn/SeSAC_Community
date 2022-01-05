//
//  CommentTableView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/05.
//

import UIKit

class CommentTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        register(CommentTableViewCell.self, forCellReuseIdentifier: "cell")
        isScrollEnabled = false
        bounces = false
        separatorStyle = .none
    }
}
