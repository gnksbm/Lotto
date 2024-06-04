//
//  LottoViewController.swift
//  Lotto
//
//  Created by gnksbm on 6/4/24.
//

import UIKit

import Alamofire

class LottoViewController: UIViewController {
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
        fetchLottoData()
    }
    
    private func fetchLottoData() {
        if let url = LottoResponse.url {
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
        [ballStackView, descriptionLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
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
