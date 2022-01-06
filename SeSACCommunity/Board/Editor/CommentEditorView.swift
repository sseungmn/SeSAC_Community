//
//  CommentEditorView.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/06.
//

import UIKit

class CommentEditorView: BaseView {
    
    let editorTextView = UITextView().then { textView in
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraint() {
        addSubview(editorTextView)
        editorTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    override func configure() {
        editorTextView.becomeFirstResponder()
    }
}
