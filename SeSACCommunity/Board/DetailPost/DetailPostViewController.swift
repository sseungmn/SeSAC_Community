//
//  DetailPostViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/04.
//

import UIKit

class DetailPostViewController: BaseViewController {

    let mainView = DetailPostView()
    var post: Post?
    var comments: Comments?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        view.backgroundColor = .white
        
        guard let post = post else { return }
        mainView.usernameLabel.text = post.user.username
        mainView.dateLabel.text = post.createdAt
        mainView.postBodyLabel.text = post.text
        mainView.commentInfoStackView.descriptionLabel.text = "댓글 \(post.comments.count)"
        APIService.requestCommentRead(postID: post.id) { comments, error in
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
        let color =  UIColor(red: .random(in: 0...1),
                             green: .random(in: 0...1),
                             blue: .random(in: 0...1),
                             alpha: 0.5)
        cell.backgroundColor = color
        guard let commnet = comments?[indexPath.row] else { return UITableViewCell() }
        cell.usernameLabel.text = commnet.user.username
        cell.commentLabel.text = commnet.comment
        return cell
    }
}
