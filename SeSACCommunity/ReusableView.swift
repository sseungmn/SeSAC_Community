//
//  CustomTextField.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import UIKit
import SnapKit

// MARK: CustomTextField
class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5.0
        
        tintColor = .lightGray
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 13, dy: 13)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 13, dy: 13)
    }
}

// MARK: CustomButton
class CustomButton: UIButton {
    
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

// MARK: Separator View
class SeparatorView: UIView {
    private var height: CGFloat = 0
    
    enum SeparatorType {
        case `default`, thick
    }
    
    convenience init(of type: SeparatorType) {
        self.init(frame: .zero)
        switch type {
        case .default: self.height = 3.0
        case .thick: self.height = 8.0
        }
    }
    
    func setFrame(from bounds: CGRect) {
        var frame = bounds
        frame = CGRect(x: 0,
                       y: frame.size.height - height,
                       width: frame.size.width,
                       height: height)
        self.frame = frame
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
