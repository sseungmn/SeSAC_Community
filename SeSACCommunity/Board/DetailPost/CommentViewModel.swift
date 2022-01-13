//
//  CommentViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/13.
//

import Foundation

import RxSwift
import RxCocoa

class CommentViewModel: BaseViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let inputText = PublishRelay<String>()
    let readComment = PublishRelay<Void>()
    let deleteComment = PublishRelay<Int>()
    let updateComment = PublishRelay<Comment>()
    
    struct Input {
        let saveButtonTap: Observable<ControlEvent<Void>.Element>
        let textFieldText: Observable<ControlProperty<String>.Element>
        let postID: Observable<Int>
    }
    
    struct Output {
        let createResult: Observable<Void>
        let readResult: Observable<Comments>
        let updateResult: Observable<Comment>
        let deleteResult: Observable<Void>
        
//        let isOwner: Observable<Bool>
        let isCommentEmpty: SharedSequence<DriverSharingStrategy, Bool>
        let cleanCommentText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        input.textFieldText
            .bind(to: inputText)
            .disposed(by: disposeBag)
        
        let isCommentEmpty = input.textFieldText
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: true)
        
        let createResult = input.saveButtonTap
            .withLatestFrom(
                Observable.combineLatest(inputText.asObservable(), input.postID)
            )
            .flatMapLatest(requestCreate)
        
        let cleanCommentText = input.saveButtonTap
            .map { "" }
        
        let readResult = readComment
            .withLatestFrom(input.postID)
            .flatMapLatest(requestRead)
        
        let deleteResult = deleteComment
            .asObservable()
            .flatMapLatest(requestDelete)
        
        let updateResult = updateComment
            .asObservable()
        
        return Output(createResult: createResult,
//                      isOwner: ,
                      readResult: readResult,
                      updateResult: updateResult,
                      deleteResult: deleteResult,
                      isCommentEmpty: isCommentEmpty,
                      cleanCommentText: cleanCommentText
        )
    }
    
    func requestCreate(comment: String, postID: Int) -> Observable<Void> {
        return Observable<Void>.create { observer in
            APIService.requestCreateComment(comment: comment, postID: postID) { _, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func requestRead(postID: Int) -> Observable<Comments> {
        return Observable<Comments>.create { observer in
            APIService.requestReadComment(postID: postID) { comments, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let comments = comments else { return }
                observer.onNext(comments)
            }
            return Disposables.create()
        }
    }
    
    func requestDelete(commentID: Int) -> Observable<Void> {
        return Observable<Void>.create { observer in
            APIService.requestDeleteComment(commentID: commentID) { _, error in
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
