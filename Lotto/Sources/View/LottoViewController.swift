//
//  LottoViewController.swift
//  Lotto
//
//  Created by gnksbm on 6/4/24.
//

import UIKit

import Alamofire

class LottoViewController: UIViewController {
    private lazy var textField = {
        let textField = UITextField()
        textField.placeholder = "회차번호를 입력해주세요"
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.addTarget(
            self,
            action: #selector(fetchButtonTapped),
            for: .editingDidEndOnExit
        )
        return textField
    }()
    
    private lazy var fetchButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("검색", for: .normal)
        button.addTarget(
            self,
            action: #selector(fetchButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private let ballViews = {
        LottoBallType.allCases.map { ballType in
            let ballView = LottoBallView()
            ballView.tag = ballType.rawValue
            return ballView
        }
    }()
    
    private lazy var ballStackView = {
        var ballViews: [UIView] = ballViews
        let plusView = UIImageView()
        plusView.image = UIImage(systemName: "plus")
        plusView.preferredSymbolConfiguration
        = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 20))
        plusView.contentMode = .scaleAspectFit
        plusView.tintColor = .systemGray
        plusView.setContentHuggingPriority(
            UILayoutPriority.defaultHigh,
            for: .horizontal
        )
        ballViews.insert(
            plusView,
            at: LottoBallType.bonusNum.rawValue
        )
        let stackView = UIStackView(arrangedSubviews: ballViews)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        fetchLottoData(round: 1122)
    }
    
    @objc private func fetchButtonTapped() {
        guard let text = textField.text,
              let round = Int(text)
        else { return }
        fetchLottoData(round: round)
    }
    
    private func fetchLottoData(round: Int) {
        if let url = LottoResponse.getURL(round: round) {
            AF.request(url)
                .responseDecodable(
                    of: LottoResponse.self
                ) { [weak self] response in
                    switch response.result {
                    case .success(let result):
                        self?.ballViews.forEach { view in
                            let ballType = LottoBallType.allCases[view.tag]
                            let winningNum = result[ballType]
                            view.updateView(
                                winningNum: winningNum
                            )
                        }
                        self?.descriptionLabel.attributedText
                        = result.attributedString
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    private func configureUI() { 
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        [textField, fetchButton, ballStackView, descriptionLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.8
            ),
            textField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            textField.bottomAnchor.constraint(
                equalTo: ballStackView.topAnchor,
                constant: -40
            ),
            
            fetchButton.topAnchor.constraint(
                equalTo: textField.topAnchor,
                constant: 4
            ),
            fetchButton.trailingAnchor.constraint(
                equalTo: textField.trailingAnchor,
                constant: -4
            ),
            fetchButton.bottomAnchor.constraint(
                equalTo: textField.bottomAnchor,
                constant: -4
            ),
            
            ballStackView.bottomAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -10
            ),
            ballStackView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            descriptionLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            descriptionLabel.topAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: 10
            )
        ])
    }
}
