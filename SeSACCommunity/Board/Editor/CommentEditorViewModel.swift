//
//  CommentEditorViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/12.
//

import Foundation

import RxSwift
import RxCocoa

class CommentEditorViewModel: BaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let commentText: ControlProperty<String>
        let commentObejct: Observable<Comment>
        let saveButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let result: Observable<Void>
        let saveButtonEnable: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let result = input.saveButtonTap
            .withLatestFrom(
                Observable.combineLatest(input.commentText, input.commentObejct)
            )
            .flatMapLatest(request)
        let saveButtonEnable = input.commentText
            .map { $0.count > 0 }
        return Output(result: result, saveButtonEnable: saveButtonEnable)
    }
    
    func request(commentText: String, commentObject: Comment) -> Observable<Void> {
        let postID = commentObject.postID
        let commentID = commentObject.id
        return Observable<Void>.create { observer in
            APIService.requestUpdateComment(comment: commentText, postID: postID, commentID: commentID) { _, error in
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
