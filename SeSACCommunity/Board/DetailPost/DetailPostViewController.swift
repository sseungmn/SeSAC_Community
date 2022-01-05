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
    var postID: Int?
    var post: Post?
    var comments: Comments?
    
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
    }
    
    override func configure() {
        mainView.commentTableView.delegate = self
        mainView.commentTableView.dataSource = self
    }
    
    func requestPost() {
        guard let postID = postID else { return }
        APIService.requestReadSpecificPost(postID: postID) { [weak self] post, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let post = post else { return }

            DispatchQueue.main.async {
                self?.mainView.usernameLabel.text = post.user.username
                self?.mainView.dateLabel.text = post.createdAt.formattedDate
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
    func reloadView() {
        print("DetailPostView Reloaded")
        requestPost()
        mainView.commentTableView.reloadData()
    }
}
