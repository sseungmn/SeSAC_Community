//
//  PostEditorView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/06.
//

import UIKit

class PostEditorView: BaseView {
    
    let postTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraint() {
        addSubview(postTextView)
        postTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
