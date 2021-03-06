//
//  BoardViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/03.
//

import UIKit

import RxSwift
import RxCocoa

class BoardViewController: BaseViewController, UINavigationMemeber, UITableViewDelegate {
    
    let mainView = BoardView()
    var refreshControl = UIRefreshControl()
    let addFloatingButton = FloatingButton()
    
    let viewModel = BoardViewModel()
    var boardRelay = BehaviorRelay<Board>(value: Board())
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "새싹당근농장"
        initRefresh(with: mainView.tableView)
        viewModel.fetchBoard.accept(())
    }
    
    override func subscribe() {
        let output = viewModel.transform(input: BoardViewModel.Input())
        
        addFloatingButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presentVC(of: PostEditorViewController())
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        output.result
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] board in
                guard let board = board.element else { return }
                self?.boardRelay.accept(board)
                self?.mainView.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        boardRelay.asObservable()
            .bind(to: mainView.tableView.rx
                    .items(
                        cellIdentifier: BoardTableViewCell.reuserIdentifier,
                        cellType: BoardTableViewCell.self)
            ) { _, element, cell in
                cell.fetchInfo(cellInfo: element)
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(Post.self)
            .subscribe { [weak self] post in
                guard let post = post.element else { return }
                let vc = DetailPostViewController()
                vc.detailPostViewModel.post.accept(post)
                vc.commentViewModel.postID.accept(post.id)
                self?.pushVC(of: vc)
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
        mainView.tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.reuserIdentifier)
    }
}

// MARK: Scroll Refrech Action
extension BoardViewController: Refreshable {
    func reloadView() {
        print("BoardView Reloaded")
        viewModel.fetchBoard.accept(())
        self.mainView.tableView.reloadData()
    }
}

extension BoardViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.reloadView()
    }
}
