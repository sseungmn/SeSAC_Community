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
    }
    
    override func setConstraint() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func subscribe() {
        closeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self,
                      let text = self.mainView.postTextView.text else { return }
                switch self.mode {
                case .create:
                    APIService.requestCreatePost(text: text) { _, error in
                        guard error == nil else { return }
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                case .update:
                    guard let post = self.post else { return }
                    APIService.requestUpdatePost(postID: post.id, text: text) { _, error in
                        guard error == nil else { return }
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
