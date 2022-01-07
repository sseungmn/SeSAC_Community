//
//  CommentEditorViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/06.
//

import UIKit

class CommentEditorViewController: BaseViewController, UINavigationMemeber {
    
    let mainView = CommentEditorView()
    
    var comment: Comment?
    
    let saveButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "댓글 수정"
        navigationItem.rightBarButtonItem = saveButton
        
        if let comment = comment {
            mainView.editorTextView.text = comment.comment
        }
    }
    
    override func setConstraint() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }
    
    override func subscribe() {
        mainView.editorTextView.rx.text
            .orEmpty
            .map { $0.count > 0 }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        saveButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self,
                      let postID = self.comment?.postID,
                      let commentID = self.comment?.id,
                      let comment = self.mainView.editorTextView.text
                else { return }
                print("postID:\(postID), commentID: \(commentID), comment: \(comment)")
                APIService.requestUpdateComment(comment: comment, postID: postID, commentID: commentID) { _, error in
                    guard error == nil else {
                        print("수정 불가, \(error!)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
