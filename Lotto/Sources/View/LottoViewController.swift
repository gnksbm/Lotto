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
    private let textFieldFont = UIFont.systemFont(ofSize: 20, weight: .medium)
    private lazy var roundPicker = UIPickerView().build { builder in
        builder.delegate(self)
            .dataSource(self)
    }
    
    private lazy var textField = UITextField().build { builder in
        builder.placeholder("\(fieldDescription)를 입력해주세요")
            .text(LottoAnnouncement.roundRange.last?.description)
            .inputView(roundPicker)
            .textAlignment(.center)
            .font(textFieldFont)
            .action {
                $0.layer.borderWidth = 2
                $0.layer.borderColor = UIColor.tertiarySystemFill.cgColor
                $0.layer.cornerRadius = 4
                $0.addTarget(
                    self,
                    action: #selector(fetchButtonTapped),
                    for: .editingDidEndOnExit
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
        [textField, ballStackView, descriptionLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 20
            ),
            textField.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.9
            ),
            textField.heightAnchor.constraint(
                equalToConstant: textFieldFont.lineHeight * 2
            ),
            textField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
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

extension LottoViewController: UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        "\(row + 1)"
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        textField.text = "\(row + 1)"
        fetchButtonTapped()
    }
}

extension LottoViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        LottoAnnouncement.roundRange.count
    }
}
