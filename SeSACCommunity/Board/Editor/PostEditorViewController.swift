//
//  PostEditorViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/06.
//

import UIKit
import RxSwift
import RxRelay

class PostEditorViewController: BaseViewController {
    
    let mainView = PostEditorView()
    
    var postBody = ""
    
    let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: nil)
    let saveButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "새싹당근농장 글쓰기"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func setConstraint() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func subscribe() {
        mainView.postTextView.rx.text
            .orEmpty
            .subscribe { [weak self] value in
                guard let text = value.element else { return }
                self?.postBody = text
            }
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                APIService.requestCreatePost(text: self.postBody) { post, error in
                    guard error == nil else { return }
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
