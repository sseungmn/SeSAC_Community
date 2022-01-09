//
//  CustomAlert.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/06.
//

import UIKit

class BasicAlertController: UIAlertController {
    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    init(title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.message = message
        print("Basic Alert Presented")
        addAction(okAction)
        addAction(cancelAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
