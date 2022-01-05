//
//  PostEditorViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/06.
//

import UIKit

class PostEditorViewController: BaseViewController {
    
    let mainView = PostEditorView()
    
    override func loadView() {
        view = mainView
        navigationItem.title = "새싹당근농장 글쓰기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelEditing))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(cancelEditing))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc
    func cancelEditing() {
        self.dismiss(animated: true) {
        }
    }
}
