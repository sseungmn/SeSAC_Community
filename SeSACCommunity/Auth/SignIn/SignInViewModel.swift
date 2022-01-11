//
//  SignInViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/10.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

class SignInViewModel {
    
    typealias UserInput = (username: String, password: String)
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let confirmButtonTap = PublishRelay<Void>()
    let usernameChanged = PublishRelay<String>()
    let passwordChanged = PublishRelay<String>()
    
    lazy var result = confirmButtonTap
        .withLatestFrom(Observable.combineLatest(self.usernameChanged, self.passwordChanged))
        .flatMapLatest(requestSignIn)
        .observe(on: MainScheduler.instance)
    
    func requestSignIn(userInput: UserInput) -> Observable<Void> {
        return Observable.create { observer in
            APIService.requestSignIn(username: userInput.username, password: userInput.password) { userData, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let userData = userData else { return }
                UserInfo.jwt = userData.jwt
                UserInfo.id = userData.user.id
                UserInfo.username = userInput.username
                UserInfo.password = userInput.password
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
}
