//
//  BaseViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/03.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraint()
        subscribe()
    }
    
    func configure() {
        view.backgroundColor = .white
    }
    
    func setConstraint() {
        
    }
    
    func subscribe() {
        
    }
}
