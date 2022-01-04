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
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
