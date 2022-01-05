//
//  DetailPostViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/04.
//

import UIKit
import RxSwift

class DetailPostViewController: BaseViewController {
    
    var refreshControl = UIRefreshControl()

    let mainView = DetailPostView()
    var post: Post?
    var comments: Comments?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBoard()
        initRefresh(with: mainView.scrollView)
    }
    
    override func setConstraint() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configure() {
        mainView.commentTableView.delegate = self
        mainView.commentTableView.dataSource = self
    }
    
    func fetchBoard() {
        guard let post = post else { return }
        mainView.usernameLabel.text = post.user.username
        mainView.dateLabel.text = post.createdAt
        mainView.postBodyLabel.text = post.text
        mainView.commentInfoStackView.descriptionLabel.text = "댓글 \(post.comments.count)"
        fetchComment(postID: post.id)
    }
    
    func fetchComment(postID: Int) {
        APIService.requestCommentRead(postID: postID) { comments, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let comments = comments else { return }
            self.comments = comments
            print(comments)
            DispatchQueue.main.async { [weak self] in
                self?.mainView.commentTableView.reloadData()
            }
        }
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
        cell.usernameLabel.text = commnet.user.username
        cell.commentLabel.text = commnet.comment
        return cell
    }
}

extension DetailPostViewController: Refreshable {
    func refreshAction() {
        print("DetailPostView Refreshed")
        fetchBoard()
        mainView.commentTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}
