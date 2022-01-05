//
//  CustomTextField.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import UIKit
import SnapKit

// MARK: CustomTextField
class InsetTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 13, dy: 13)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 13, dy: 13)
    }
}

final class FormTextField: InsetTextField {
    
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
}

// MARK: CustomButton
final class CustomButton: UIButton {
    
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
final class SeparatorView: UIView {
    private var height: CGFloat = 0
    
    enum SeparatorType {
        case `default`, thick
    }
    
    convenience init(of type: SeparatorType) {
        self.init(frame: .zero)
        switch type {
        case .default: self.height = 1.0
        case .thick: self.height = 8.0
        }
    }
    
    func setFrame(from targetFrame: CGRect) {
        var frame = targetFrame
        frame = CGRect(x: frame.origin.x,
                       y: frame.origin.y + frame.size.height - height,
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

// MARK: AddButton
final class FloatingButton: UIButton {
    static private let size: CGFloat = 70
    
    private let cornerRadius: CGFloat = size / 2
    private let fillColor: UIColor = .themeColor
    private let shadowColor: UIColor = .black
    
    private let symbolConfiuration = UIImage.SymbolConfiguration(pointSize: size / 2)
    
    convenience init(type: ButtonType) {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstrints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstrints() {
        self.snp.makeConstraints { make in
            make.size.equalTo(FloatingButton.size)
        }
    }
    
    private func configure() {
        backgroundColor = .themeColor
        tintColor = .white
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2.0
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        
        setPreferredSymbolConfiguration(symbolConfiuration, forImageIn: .normal)
    }
}

class CommentInfoStackView: UIStackView {
    
    let iconImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "bubble.right")!
        imageView.tintColor = .lightGray
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    let descriptionLabel = UILabel().then { label in
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        axis = .horizontal
        distribution = .fill
        spacing = 10.0
        layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        isLayoutMarginsRelativeArrangement = true
        
        addArrangedSubview(iconImageView)
        addArrangedSubview(descriptionLabel)
    }
}
