//
//  ViewController.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/01.
//

import UIKit

class WelcomeViewController: BaseViewController {
    
    let mainView = WelcomeView()
    
    let viewModel = WelcomeViewModel()
    
    private lazy var input = WelcomeViewModel.Input(
        startButtonTap: self.mainView.startButton.rx
            .tap
            .asObservable(),
        fotterLabelTap: self.mainView.fotterLabel.rx
            .tapGesture()
            .when(.recognized)
    )
    private lazy var output = viewModel.transform(input: input)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        output.pushSignUpVC
            .subscribe { [weak self] _ in
                self?.pushVC(of: SignUpViewController())
            }
            .disposed(by: disposeBag)
        output.pushSignInVC
            .subscribe { [weak self] gesture in
                guard let self = self,
                      let text = self.mainView.fotterLabel.text,
                      let gesture = gesture.element else { return }
                let loginTextRange = (text as NSString).range(of: "로그인")
                
                if gesture.didTapAttributedTextInLabel(label: self.mainView.fotterLabel, inRange: loginTextRange) {
                    self.pushVC(of: SignInViewController())
                }
            }
            .disposed(by: disposeBag)
    }
}
