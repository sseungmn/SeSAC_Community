//
//  BoardViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/03.
//

import UIKit
import RxSwift

class BoardViewController: BaseViewController, UINavigationMemeber {
    
    var board = [Post]()
    var refreshControl = UIRefreshControl()
    
    let mainView = BoardView()
    let addFloatingButton = FloatingButton(type: .custom)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "새싹당근농장"
        mainView.setDelegate(self)
        initRefresh(with: mainView.tableView)
        fetchBoard()
    }
    
    func fetchBoard() {
        APIService.requestReadPost { board, error in
            guard error == nil else {
                print(error!)
                return

            }
            guard let board = board else { return }
            self.board = board
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    override func subscribe() {
        addFloatingButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presentVC(of: PostEditorViewController())
            }
            .disposed(by: disposeBag)
    }
    
    override func setConstraint() {
        view.addSubview(addFloatingButton)
        addFloatingButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configure() {
        let image = UIImage(systemName: "pencil")!.withRenderingMode(.alwaysTemplate)
        addFloatingButton.setImage(image, for: .normal)
    }
}

extension BoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return board.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as? BoardTableViewCell else { return UITableViewCell() }
        let post = board[indexPath.row]
        print("===============\n\(post.id)\n\(post.text)")
        cell.bodyLabel.text = post.text
        cell.userNameLabel.text = post.user.username
        cell.dateLabel.text = post.updatedAt
        switch post.comments.count {
        case 0: cell.commentInfoStackView.descriptionLabel.text = "댓글 쓰기"
        default: cell.commentInfoStackView.descriptionLabel.text = "댓글 \(post.comments.count)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = board[indexPath.row]
        let vc = DetailPostViewController()
        vc.postID = post.id
        pushVC(of: vc)
    }
}

// MARK: Scroll Refrech Action
extension BoardViewController: Refreshable {
    func reloadView() {
        print("BoardView Reloaded")
        self.fetchBoard()
        self.mainView.tableView.reloadData()
    }
}

extension BoardViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.reloadView()
    }
}
