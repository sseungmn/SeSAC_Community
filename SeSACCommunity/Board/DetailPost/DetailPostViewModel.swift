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
    
    let readPost = PublishRelay<Void>()
    let updatePost = PublishRelay<Void>()
    let deletePost = PublishRelay<Void>()
    
    struct Input {
//        let postID: Observable<Int>
    }
    
    struct Output {
        let isPostOwner: Observable<Bool>
        let readResult: Observable<Post>
        let deleteResult: Observable<Void>
        let updateResult: Observable<Post>
    }
    
    func transform(input: Input) -> Output {
        let postID = post
            .filter { $0 != nil }
            .map { $0!.id }
        
        let isPostOwner = post
            .filter { $0 != nil }
            .map { $0!.user.id == UserInfo.id }
            .filter { $0 }
        
        let readResult = readPost
            .withLatestFrom(postID)
            .flatMapLatest(requestRead)
        
        let deleteResult = deletePost
            .withLatestFrom(postID)
            .flatMapLatest(requestDelete)
        
        let updateResult = updatePost
            .withLatestFrom(post)
            .filter { $0 != nil }
            .map { $0! }
            .asObservable()
        
        return Output(
            isPostOwner: isPostOwner,
            readResult: readResult,
            deleteResult: deleteResult,
            updateResult: updateResult
        )
    }
    
    func requestRead(postID: Int) -> Observable<Post> {
        print("postID : \(postID)")
        return Observable.create { observer in
            APIService.requestReadSpecificPost(postID: postID) { post, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let post = post else { return }
                observer.onNext(post)
            }
            return Disposables.create()
        }
    }
    
    func requestDelete(postID: Int) -> Observable<Void> {
        return Observable<Void>.create { observer in
            APIService.requestDeletePost(postID: postID) { _, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
}
