//
//  CommentEditorViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/06.
//

import UIKit

import RxSwift

class CommentEditorViewController: BaseViewController, UINavigationMemeber {
    
    let mainView = CommentEditorView()
    let viewModel = CommentEditorViewModel()
    
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
        guard let comment = comment else { return }
        let input = CommentEditorViewModel.Input(
            commentText: mainView.editorTextView.rx.text.orEmpty,
            commentObejct: Observable.just(comment),
            saveButtonTap: saveButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.saveButtonEnable
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.result
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}
