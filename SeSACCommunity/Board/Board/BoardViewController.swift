//
//  BoardViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class BoardViewController: BaseViewController, UINavigationMemeber {
    
    var board = [Post]()
    var boardRelay = BehaviorRelay<Board>(value: Board())
    
    var refreshControl = UIRefreshControl()
    
    let mainView = BoardView()
    let addFloatingButton = FloatingButton()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "새싹당근농장"
        bind()
//        mainView.setDelegate(self)
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
            self.boardRelay.accept(board)
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

extension BoardViewController: UITableViewDelegate {
    func bind() {
        mainView.tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.reuserIdentifier)
        mainView.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        boardRelay.asObservable()
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: BoardTableViewCell.reuserIdentifier, cellType: BoardTableViewCell.self
            )) { _, element, cell in
                
                cell.bodyLabel.text = element.text
                cell.userNameLabel.text = element.user.username
                cell.dateLabel.text = element.updatedAt.toDate.toRelativeTodayTime
                switch element.comments.count {
                case 0:
                    cell.commentInfoStackView.descriptionLabel.text = "댓글 쓰기"
                default:
                    cell.commentInfoStackView.descriptionLabel.text = "댓글 \(element.comments.count)"
                }
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(Post.self)
            .subscribe { [weak self] post in
                guard let post = post.element else { return }
                let vc = DetailPostViewController()
                vc.postRelay.accept(post)
                vc.post = post
                self?.pushVC(of: vc)
            }
            .disposed(by: disposeBag)
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
