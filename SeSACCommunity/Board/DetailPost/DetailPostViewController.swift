//
//  DetailPostViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/04.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

class DetailPostViewController: BaseViewController {
    
    var refreshControl = UIRefreshControl()
    
    let mainView = DetailPostView()
    var postID = BehaviorSubject<Int>(value: 0)
    var post: Post?
    var commentArray = BehaviorRelay<Comments>(value: Comments())
    
    let detailPostViewModel = DetailPostViewModel()
    let commentViewModel = CommentViewModel()
    
    let moreActionButton = UIBarButtonItem(image: UIImage(named: "ellipsis.vertical"),
                                           style: .plain,
                                           target: self,
                                           action: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh(with: mainView.scrollView)
        bindComment()
        bindDetailPost()
        bindTable()
    }
    
    override func setConstraint() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configure() {
        mainView.commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.reuserIdentifier)
    }
    
    func bindComment() {
        let input = CommentViewModel.Input(
            saveButtonTap: mainView.commentSaveButton.rx.tap
                .share(replay: 1, scope: .whileConnected),
            textFieldText: mainView.commentTextField.rx.text
                .orEmpty
                .distinctUntilChanged()
                .share(replay: 1, scope: .whileConnected),
            postID: postID.asObservable()
        )
        let output = commentViewModel.transform(input: input)
            
        output.isCommentEmpty
            .drive(mainView.commentSaveButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.cleanCommentText
            .bind(to: mainView.commentTextField.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: CRUD
        output.createResult
            .subscribe { [weak self] in
                self?.reloadView()
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
        output.readResult
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] comments in
                self?.commentArray.accept(comments)
                self?.mainView.commentTableView.reloadData()
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
        output.deleteResult
            .subscribe { [weak self] in
                self?.reloadView()
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        output.updateResult
            .subscribe { [weak self] comment in
                guard let comment = comment.element else { return }
                let vc = CommentEditorViewController()
                vc.comment = comment
                self?.pushVC(of: vc)
            }
            .disposed(by: disposeBag)
    }
    
    func bindDetailPost() {
        let input = DetailPostViewModel.Input()
        let output = detailPostViewModel.transform(input: input)
        
        output.isPostOwner
            .subscribe { [weak self] _ in
                self?.navigationItem.rightBarButtonItem = self?.moreActionButton
            }
            .disposed(by: disposeBag)
        
        moreActionButton.rx.tap
            .subscribe { _ in
                self.showPostActionSheet()
            }
            .disposed(by: disposeBag)
        
    }
}

extension DetailPostViewController: UITableViewDelegate {
    func bindTable() {
        mainView.commentTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        commentArray.asObservable()
            .bind(to: mainView.commentTableView.rx.items(
                cellIdentifier: CommentTableViewCell.reuserIdentifier,
                cellType: CommentTableViewCell.self)
            ) { _, element, cell in
                cell.fetchInfo(cellInfo: element)
                cell.moreActionButton.rx.tap
                    .subscribe { [weak self] _ in
                        self?.showCommentActionSheet(comment: element)
                    }
                    .disposed(by: cell.disposeBag)
                // 아래는 너무 Rx를 위한 Rx같음..
//                Observable.just(element.user.id)
//                    .map { $0 != UserInfo.id }
//                    .bind(to: cell.moreActionButton.rx.isHidden)
//                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Reload
extension DetailPostViewController: Refreshable {
    func reloadView() {
        DispatchQueue.main.async {
            print("DetailPostView Reloaded")
            self.requestPost()
            self.mainView.commentTableView.reloadData()
        }
    }
}

// MARK: Request
extension DetailPostViewController {
    func requestPost() {
        guard let postID = post?.id else { return }
        APIService.requestReadSpecificPost(postID: postID) { [weak self] post, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let post = post else { return }
            self?.post = post
            
            DispatchQueue.main.async {
                self?.mainView.usernameLabel.text = post.user.username
                self?.mainView.dateLabel.text = post.createdAt.toDate.toAbsoluteTime
                self?.mainView.postBodyLabel.text = post.text
                self?.mainView.commentInfoStackView.descriptionLabel.text = "댓글 \(post.comments.count)"
                self?.commentViewModel.readComment.accept(())
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.mainView.drawSeparator()
                }
            }
        }
    }
}

// MARK: ActionSheet
extension DetailPostViewController {
    func showPostActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        guard let postID = post?.id else { return }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            APIService.requestDeletePost(postID: postID) { _, error in
                guard error == nil else {
                    if error == .unauthorized {
                        
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        let updateAction = UIAlertAction(title: "글 수정", style: .default) { _ in
            guard let post = self.post else { return }
            let vc = PostEditorViewController()
            vc.post = post
            self.presentVC(of: vc)
        }
        
        let cancelAction = UIAlertAction(title: "글 닫기", style: .cancel, handler: nil)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(updateAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showCommentActionSheet(comment: Comment) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "댓글 삭제", style: .destructive) { _ in
            self.commentViewModel.deleteComment.accept(comment.id)
        }
        let updateAction = UIAlertAction(title: "댓글 수정", style: .default) { _ in
            self.commentViewModel.updateComment.accept(comment)
        }
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(updateAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
}
