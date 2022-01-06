//
//  Scrollable+Protocol.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/05.
//

import UIKit
import RxSwift

protocol Refreshable where Self: BaseViewController {
    var refreshControl: UIRefreshControl { get set }
    func initRefresh<View: UIScrollView>(with refreshableView: View)
    func reloadView()
}

extension Refreshable {
    func initRefresh<View: UIScrollView>(with refreshableView: View) {
        refreshableView.refreshControl = refreshControl
        
        let refresh = refreshControl.rx.controlEvent(.valueChanged)
            .observe(on: MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
        
        refresh
            .subscribe { [weak self] _ in
                self?.reloadView()
                self?.refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
}
