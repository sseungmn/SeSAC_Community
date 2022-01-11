//
//  SignUpViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/11.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

class SignUpViewModel {
    typealias UserInput = (email: String, username: String, password: String)
    
    struct Input {
        let email: ControlProperty<String>
        let username: ControlProperty<String>
        let password: ControlProperty<String>
        let passwordCheck: ControlProperty<String>
        let confirmButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isValid: Observable<Bool>
        let result: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let userInfo = Observable.combineLatest(input.email, input.username, input.password)
        
        let result = input.confirmButtonTap
            .withLatestFrom(userInfo)
            .flatMapLatest(request)
            .observe(on: MainScheduler.instance)
        
        // MARK: Validation
        let emailValid = input.email
            .map {
                $0.components(separatedBy: ["@", "."])
                .filter { !$0.isEmpty }
                .count == 3
            }
            .share(replay: 1, scope: .whileConnected)
        let usernameValid = input.username
            .map { !$0.isEmpty }
            .share(replay: 1, scope: .whileConnected)
        let passwordValid = input.password
            .map { !$0.isEmpty }
            .share(replay: 1, scope: .whileConnected)
        let passwordCheckValid = input.passwordCheck
            .map { !$0.isEmpty }
            .share(replay: 1, scope: .whileConnected)
        let passwordSame = Observable.combineLatest(input.password, input.passwordCheck) { $0 == $1 }
        
        let isValid = Observable.combineLatest(emailValid, usernameValid, passwordValid, passwordCheckValid, passwordSame) { $0 && $1 && $2 && $3 && $4}
            .share(replay: 1, scope: .whileConnected)
        
        return Output(isValid: isValid, result: result)
    }
    
    func request(userInput: UserInput) -> Observable<Void> {
        return Observable<Void>.create { observer in
            APIService.requestSignUp(username: userInput.username,
                                     email: userInput.email,
                                     password: userInput.password) { userInfo, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let userInfo = userInfo else { return }
                UserInfo.jwt = userInfo.jwt
                UserInfo.id = userInfo.user.id
                UserInfo.username = userInput.username
                UserInfo.password = userInput.password
                
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
}
