//
//  BoardViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/03.
//

import UIKit

class BoardViewController: BaseViewController, UINavigationMemeber {
    
    var board = [Post]()
    
    let mainView = BoardView()
    let addFloatingButton = FloatingButton(type: .custom)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "새싹당근농장"
        mainView.setDelegate(self)
        APIService.requestPostRead { board, error in
            guard let board = board else {
                return
            }
            self.board = board
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
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
        cell.bodyLabel.text = board[indexPath.row].text
        cell.userNameLabel.text = board[indexPath.row].user.username
        cell.dateLabel.text = board[indexPath.row].updatedAt
        return cell
    }
}
