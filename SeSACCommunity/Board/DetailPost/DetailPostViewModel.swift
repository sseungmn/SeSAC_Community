//
//  DetailPostViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/13.
//

import Foundation

import RxSwift
import RxCocoa

class DetailPostViewModel: BaseViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let post = BehaviorRelay<Post?>(value: nil)
    
    struct Input {
    }
    
    struct Output {
        let isPostOwner: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let isPostOwner = post
            .map { $0?.user.id == UserInfo.id }
            .filter { $0 }
        return Output(isPostOwner: isPostOwner)
    }
}
