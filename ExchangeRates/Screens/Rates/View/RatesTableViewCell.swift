//
//  RatesTableViewCell.swift
//  ExchangeRates
//
//  20/08/2018.
//

import UIKit
import PinLayout

final class RatesTableViewCell: UITableViewCell {

    // MARK: - Subviews

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let textField = UITextField()

    // MARK: - Constants

    static let reuseIdentifier: String = String(describing: RatesTableViewCell.self)

    private enum Constants {
        static let defaultMargin: CGFloat = 8
    }

    // MARK: - Initialization and deinitialization

    init() {
        super.init(style: .default, reuseIdentifier: RatesTableViewCell.reuseIdentifier)
        backgroundColor = .white

        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        subtitleLabel.textColor = .black
        contentView.addSubview(titleLabel)

        subtitleLabel.numberOfLines = 1
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        contentView.addSubview(subtitleLabel)

        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .black
        textField.text = "0"
        textField.keyboardType = .decimalPad
        textField.returnKeyType = .done
        contentView.addSubview(textField)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UITableViewCell

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    // MARK: - Internal methods

    func configure(with str: String) {
        self.titleLabel.text = str
        self.subtitleLabel.text = "Some Text"
    }

    // MARK: - Private methods

    private func layout() {
        titleLabel.pin
            .top(contentView.pin.safeArea)
            .start(contentView.pin.safeArea)
            .margin(Constants.defaultMargin)
            .sizeToFit()

        subtitleLabel.pin
            .below(of: titleLabel, aligned: HorizontalAlign.start)
            .bottom(contentView.pin.safeArea)
            .marginStart(0)
            .marginTop(Constants.defaultMargin)
            .marginBottom(Constants.defaultMargin)
            .sizeToFit()

        textField.pin
            .vCenter()
            .end(contentView.pin.safeArea)
            .height(20)
            .margin(Constants.defaultMargin)
            .sizeToFit()
    }

}
