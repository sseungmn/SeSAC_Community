//
//  DetailPostViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/04.
//

import UIKit

class DetailPostViewController: BaseViewController {

    let mainView = DetailPostView()
    
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
    }
}

extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        guard let cell = mainView.commentTableView.dequeueReusableCell(withIdentifier: "cell") as? CommentTableViewCell else { return UITableViewCell() }
        let color =  UIColor(red: .random(in: 0...1),
                             green: .random(in: 0...1),
                             blue: .random(in: 0...1),
                             alpha: 0.5)
        cell.backgroundColor = color
        return cell
    }
}
