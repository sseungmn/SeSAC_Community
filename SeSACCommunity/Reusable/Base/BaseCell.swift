//
//  BaseCell.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/13.
//

import UIKit

import RxSwift

protocol ReusableView {
    static var reuserIdentifier: String { get }
}

class BaseCell: UITableViewCell, ReusableView {
    static var reuserIdentifier: String {
        return String(describing: self)
    }
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
    
    func setConstraint() {}
    
    func fetchInfo<T>(cellInfo: T) {
        
    }
}
