//
//  WelcomeViewModel.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/10.
//

import Foundation

import RxSwift
import RxCocoa
import RxGesture

class WelcomeViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    
    struct Input {
        let startButtonTap: Observable<Void>
        let fotterLabelTap: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let pushSignUpVC: Observable<Void>
        let pushSignInVC: Observable<UITapGestureRecognizer>
    }
    
    func transform(input: Input) -> Output {
        return Output(pushSignUpVC: input.startButtonTap,
                      pushSignInVC: input.fotterLabelTap)
    }
}
