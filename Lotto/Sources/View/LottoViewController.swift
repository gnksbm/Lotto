//
//  LottoViewController.swift
//  Lotto
//
//  Created by gnksbm on 6/4/24.
//

import UIKit

import Alamofire

class LottoViewController: UIViewController {
    private let fieldDescription = "회차번호"
    private lazy var textField = UITextField().build { builder in
        builder.placeholder("\(fieldDescription)를 입력해주세요")
            .action {
                $0.layer.borderWidth = 1
                $0.layer.cornerRadius = 4
                $0.addTarget(
                    self,
                    action: #selector(fetchButtonTapped),
                    for: .editingDidEndOnExit
                )
            }
    }
    
    private lazy var fetchButton
    = UIButton(configuration: .filled()).build { builder in
        builder.action {
            $0.setTitle("검색", for: .normal)
            $0.addTarget(
                self,
                action: #selector(fetchButtonTapped),
                for: .touchUpInside
            )
        }
    }
    
    private let ballViews = LottoBallType.allCases.map { ballType in
        LottoBallView().build { builder in
            builder.tag(ballType.rawValue)
        }
    }
    
    private let plusView = UIImageView().build { builder in
        builder.contentMode(.scaleAspectFit)
            .image(UIImage(systemName: "plus"))
            .preferredSymbolConfiguration(
                UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 20))
            )
            .tintColor(.systemGray)
            .action {
                $0.setContentHuggingPriority(
                    UILayoutPriority.defaultHigh,
                    for: .horizontal
                )
            }
    }
    
    private lazy var arrangedSubviews = {
        var arrangedSubviews: [UIView] = ballViews
        arrangedSubviews.insert(
            plusView,
            at: LottoBallType.bonusNum.rawValue
        )
        return arrangedSubviews
    }()
    
    private lazy var ballStackView
    = UIStackView(arrangedSubviews: arrangedSubviews).build { builder in
        builder.axis(.horizontal)
            .spacing(10)
            .distribution(.equalSpacing)
    }
    
    private let descriptionLabel = UILabel().build { builder in
        builder.textAlignment(.center)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        fetchRecentlyLotto()
    }
    
    @objc 
    private func fetchButtonTapped() {
        do {
            let round = try NumericValidator.validateInput(
                input: textField.text,
                range: LottoAnnouncement.roundRange,
                inputDescription: fieldDescription
            )
            fetchLottoData(round: round)
        } catch {
            descriptionLabel.text = error.localizedDescription
        }
    }
    
    private func fetchRecentlyLotto() {
        LottoAnnouncement.updateLatestInfo { [weak self] lotto in
            self?.updateView(with: lotto)
        }
    }
    
    private func fetchLottoData(round: Int) {
        if let url = APIURL.lottoURL(round: round) {
            AF.request(url).responseDecodable(
                of: LottoResponse.self
            ) { [weak self] response in
                guard let self else { return }
                switch response.result {
                case .success(let lotto):
                    updateView(with: lotto)
                case .failure:
                    descriptionLabel.text = "잘못된 요청입니다"
                }
            }
        }
    }
    
    private func updateView(with lotto: LottoResponse) {
        ballViews.forEach { view in
            let ballType = LottoBallType.allCases[view.tag]
            let winningNum = lotto[ballType]
            view.updateView(
                winningNum: winningNum
            )
        }
        descriptionLabel.attributedText = lotto.attributedString
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
