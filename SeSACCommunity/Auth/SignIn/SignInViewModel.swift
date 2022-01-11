//
//  SignInViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/10.
//

import Foundation
import RxSwift
import UIKit
import RxRelay
import RxCocoa

typealias SignInRequestInfo = (username: String, password: String)

class SignInViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let confirmButtonTap = PublishRelay<Void>()
    let usernameChanged = PublishRelay<String>()
    let passwordChanged = PublishRelay<String>()
    
    lazy var result = confirmButtonTap
        .withLatestFrom(Observable.combineLatest(self.usernameChanged, self.passwordChanged))
        .flatMapLatest(requestSignIn)
        .observe(on: MainScheduler.instance)
    
    func requestSignIn(userInfo: SignInRequestInfo) -> Observable<Void> {
        return Observable.create { observer in
            APIService.requestSignIn(username: userInfo.username, password: userInfo.password) { userData, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let userData = userData else { return }
                UserInfo.jwt = userData.jwt
                UserInfo.id = userData.user.id
                UserInfo.username = userInfo.username
                UserInfo.password = userInfo.password
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
}
