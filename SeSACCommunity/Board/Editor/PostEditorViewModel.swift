//
//  PostEditorViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/12.
//

import Foundation

import RxSwift
import RxCocoa

class PostEditorViewModel: BaseViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let result = PublishSubject<Void>()
    
    struct Input {
        let closeButtonTap: ControlEvent<Void>
        let saveButtonTap: Observable<Mode>
        let text: ControlProperty<String>
        let post: Post?
    }
    
    struct Output {
        let result: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let create = input.saveButtonTap
            .filter { $0 == .create }
            .withLatestFrom(input.text)
            .flatMap(requestCreate)
        
        let update = input.saveButtonTap
            .filter { $0 == .update }
            .withLatestFrom(input.text) { _, text  in
                return (input.post!.id, text)
            }
            .flatMap(requestUpdate)
        
        let result = Observable.merge(create, update, input.closeButtonTap.asObservable())
        
        return Output(result: result)
    }
    
    func requestCreate(text: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            APIService.requestCreatePost(text: text) { _, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func requestUpdate(postId: Int, text: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            APIService.requestUpdatePost(postID: postId, text: text) { _, error in
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
