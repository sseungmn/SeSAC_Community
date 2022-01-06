//
//  DetailPostViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/04.
//

import UIKit
import RxSwift
import RxRelay

class DetailPostViewController: BaseViewController {
    
    var refreshControl = UIRefreshControl()
    
    let mainView = DetailPostView()
    var postID: Int?
    var post: Post?
    var comments: Comments?
    
    let commentText = PublishRelay<String>()
    
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
    }
    
    override func setConstraint() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        navigationItem.rightBarButtonItem = moreActionButton
    }
    
    override func configure() {
        mainView.commentTableView.delegate = self
        mainView.commentTableView.dataSource = self
    }
    
    override func subscribe() {
        moreActionButton.rx.tap
            .subscribe { _ in
                self.showPostActionSheet()
            }
            .disposed(by: disposeBag)
        
        mainView.commentTextField.rx.text
            .orEmpty
            .share(replay: 1, scope: .whileConnected)
            .bind(to: commentText)
            .disposed(by: disposeBag)
        commentText
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: true)
            .drive(mainView.commentSaveButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        let commentSaveButtonTap = mainView.commentSaveButton.rx.tap
            .share(replay: 1, scope: .whileConnected)
        
        commentSaveButtonTap
            .subscribe { [weak self] _ in
                guard let comment = self?.mainView.commentTextField.text,
                      let postID = self?.postID else { return }
                
                APIService.requestCreateComment(comment: comment, postID: postID) { _, error in
                    guard error == nil else {
                        // 작성 실패했다는 오류 띄우고 끝
                        return
                    }
                    self?.reloadView()
                }
            }
            .disposed(by: disposeBag)
        
        commentSaveButtonTap
            .map { "" }
            .bind(to: mainView.commentTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let comments = comments else { return 0 }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.commentTableView.dequeueReusableCell(withIdentifier: "cell") as? CommentTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .randomColor
        guard let commnet = comments?[indexPath.row] else { return UITableViewCell() }
        print("===============\n\(commnet.id)\n\(commnet.comment)")
        cell.moreActionButton.tag = commnet.id // tag를 이용해서 해당 id를 불러올것이다.
        cell.usernameLabel.text = commnet.user.username
        cell.commentLabel.text = commnet.comment
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let commentID = comments?[indexPath.row].id else { return }
        self.showCommentActionSheet(commentID: commentID)
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
        guard let postID = postID else { return }
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
                self?.requestComment(postID: post.id)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.mainView.drawSeparator()
                }
            }
        }
    }
    
    func requestComment(postID: Int) {
        APIService.requestReadComment(postID: postID) { comments, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let comments = comments else { return }
            self.comments = comments
            DispatchQueue.main.async { [weak self] in
                self?.mainView.commentTableView.reloadData()
            }
        }
    }
    
    func deleteComment(commentID: Int) {
        APIService.requestDeleteComment(commentID: commentID) { _, error in
            guard error == nil else {
                print(error!)
                return
            }
            // 삭제가 완료됐다는 메시지
            self.reloadView()
        }
    }
}

// MARK: ActionSheet
extension DetailPostViewController {
    func showPostActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        guard let postID = postID else { return }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            APIService.requestDeletePost(postID: postID) { _, error in
                guard error == nil else {
                    print("삭제 불가")
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
    
    func showCommentActionSheet(commentID: Int) {
        print(commentID)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "댓글 삭제", style: .destructive) { _ in
            APIService.requestDeleteComment(commentID: commentID) { _, error in
                guard error == nil else {
                    print("삭제 불가, \(error!)")
                    return
                }
                self.reloadView()
            }
        }
        
        let updateAction = UIAlertAction(title: "댓글 수정", style: .default) { _ in
            let vc = CommentEditorViewController()
            self.pushVC(of: vc)
        }
        
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(updateAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
}
