//
//  CustomButton.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/07.
//

import UIKit

final class ConfirmButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = .boldSystemFont(ofSize: 20)
        setTitleColor(.white, for: .normal)
        backgroundColor = .themeColor
        layer.cornerRadius = 5.0
        snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        get {
            super.isEnabled
        }
        set(newValue) {
            if newValue == true {
                backgroundColor = .themeColor
            } else {
                backgroundColor = .lightGray
            }
        }
    }
}

// MARK: RoundButton
class RoundButton: UIButton {
    
    var size: CGFloat
    var cornerRadius: CGFloat {
        return size / 2
    }
    override var buttonType: UIButton.ButtonType {
        return .custom
    }
    
    init(size: CGFloat) {
        self.size = size
        super.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = .themeColor
        self.tintColor = .white
        self.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: size / 2),
                                             forImageIn: .normal)
        self.snp.makeConstraints { make in
            make.size.equalTo(size)
        }
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
}

final class FloatingButton: RoundButton {
   
    private let shadowColor: UIColor = .black
    
    convenience init() {
        self.init(size: 60)
    }
    
    override init(size: CGFloat) {
        super.init(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2.0
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
    }
}
