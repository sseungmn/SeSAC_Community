//
//  PostEditorViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/06.
//

import UIKit
import RxSwift
import RxRelay

enum Mode {
    case create, update
}

class PostEditorViewController: BaseViewController {
    
    let mainView = PostEditorView()
    
    var mode: Mode = .create
    var post: Post?
    
    let viewModel = PostEditorViewModel()
    
    let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: nil)
    let saveButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "새싹당근농장 글쓰기"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = saveButton
        
        if let post = post {
            mainView.postTextView.text = post.text
            mode = .update
        }
        switch mode {
        case .create:
            navigationItem.title = "새싹당근농장 글쓰기"
        case .update:
            navigationItem.title = "새싹당근농장 글수정"
        }
    }
    
    override func setConstraint() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func subscribe() {
        let input = PostEditorViewModel.Input(
            closeButtonTap: closeButton.rx.tap,
            saveButtonTap: saveButton.rx.tap.map { return self.mode },
            text: mainView.postTextView.rx.text.orEmpty,
            post: post
        )
        let output = viewModel.transform(input: input)
        
        output.result
            .observe(on: MainScheduler.instance)
            .subscribe({ [weak self]_ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
