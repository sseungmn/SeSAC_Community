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
        view.backgroundColor = .white
        configure()
        setConstraint()
        subscribe()
    }
    
    func configure() {
    }
    
    func setConstraint() {
        
    }
    
    func subscribe() {
        
    }
}
