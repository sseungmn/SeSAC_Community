//
//  BoardViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/13.
//

import Foundation

import RxSwift
import RxCocoa

class BoardViewModel: BaseViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let fetchBoard = PublishRelay<Void>()

    struct Input {
    }

    struct Output {
        let result: Observable<Board>
    }

    func transform(input: Input) -> Output {
        let result = fetchBoard
            .flatMap(request)
        return Output(result: result)
    }
    
    func request() -> Observable<Board> {
        return Observable<Board>.create { observer in
            APIService.requestReadPost { board, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let board = board else { return }
                observer.onNext(board)
            }
            return Disposables.create()
        }
    }
}
