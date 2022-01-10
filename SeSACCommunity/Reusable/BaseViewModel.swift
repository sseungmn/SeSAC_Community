//
//  BaseViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/10.
//

import Foundation
import RxSwift

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}
