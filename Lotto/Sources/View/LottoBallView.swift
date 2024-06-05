//
//  LottoBallView.swift
//  Lotto
//
//  Created by gnksbm on 6/4/24.
//

import UIKit

final class LottoBallView: UIView {
    private let numberLabel = UILabel().build { builder in
        builder
            .font(.boldSystemFont(ofSize: 20))
            .textColor(.systemBackground)
            .action {
                $0.setContentCompressionResistancePriority(
                    .required,
                    for: .horizontal
                )
            }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    func updateView(winningNum: Int) {
        numberLabel.text = "\(winningNum)"
        backgroundColor = .getLottoBallColor(winningNum: winningNum)
    }
    
    private func configureUI() {
        clipsToBounds = true
    }
    
    private func configureLayout() {
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor),
            
            numberLabel.topAnchor.constraint(
                greaterThanOrEqualTo: topAnchor,
                constant: 10
            ),
            numberLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: leadingAnchor,
                constant: 10
            ),
            numberLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -10
            ),
            numberLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: bottomAnchor,
                constant: -10
            ),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
