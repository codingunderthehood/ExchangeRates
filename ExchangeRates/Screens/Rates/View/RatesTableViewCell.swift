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

    private let currencyNameLabel = UILabel()
    private let currencyFullnameLabel = UILabel()
    private let rateTextField = UITextField()
    private let rateTextFieldUnderlineView = UIView()

    // MARK: - Constants

    static let reuseIdentifier: String = String(describing: RatesTableViewCell.self)

    private enum Constants {
        static let defaultMargin: CGFloat = 8
    }

    // MARK: - Initialization and deinitialization

    init() {
        super.init(style: .default, reuseIdentifier: RatesTableViewCell.reuseIdentifier)
        backgroundColor = .white

        currencyNameLabel.numberOfLines = 1
        currencyNameLabel.font = UIFont.systemFont(ofSize: 20)
        currencyFullnameLabel.textColor = .black
        contentView.addSubview(currencyNameLabel)

        currencyFullnameLabel.numberOfLines = 1
        currencyFullnameLabel.font = UIFont.systemFont(ofSize: 14)
        currencyFullnameLabel.textColor = .gray
        contentView.addSubview(currencyFullnameLabel)

        rateTextField.font = UIFont.systemFont(ofSize: 20)
        rateTextField.textColor = .black
        rateTextField.keyboardType = .decimalPad
        rateTextField.returnKeyType = .done
        rateTextField.addTarget(self, action: #selector(didChangeDescription), for: .editingChanged)
        rateTextField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        rateTextField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        rateTextField.textAlignment = .center
        rateTextField.isEnabled = false
        contentView.addSubview(rateTextField)

        rateTextFieldUnderlineView.backgroundColor = .lightGray
        contentView.addSubview(rateTextFieldUnderlineView)
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
        self.currencyNameLabel.text = str
        self.currencyFullnameLabel.text = "Some Text"
    }

    func startEditing() {
        rateTextField.isEnabled = true
        rateTextField.becomeFirstResponder()
    }

    // MARK: - Private methods

    private func layout() {
        currencyNameLabel.pin
            .top(contentView.pin.safeArea)
            .start(contentView.pin.safeArea)
            .margin(Constants.defaultMargin)
            .sizeToFit()

        currencyFullnameLabel.pin
            .below(of: currencyNameLabel, aligned: .start)
            .bottom(contentView.pin.safeArea)
            .marginStart(0)
            .marginBottom(Constants.defaultMargin)
            .sizeToFit()

        layoutRateTextField()
    }

    private func layoutRateTextField() {
        let maxWidth = contentView.frame.width
            - Constants.defaultMargin * 3
            - max(currencyFullnameLabel.frame.width, currencyNameLabel.frame.width)

        rateTextField.pin
            .vCenter()
            .end(contentView.pin.safeArea)
            .height(20)
            .margin(Constants.defaultMargin)
            .minWidth(20)
            .maxWidth(maxWidth)
            .sizeToFit()

        rateTextFieldUnderlineView.pin
            .below(of: rateTextField, aligned: .start)
            .height(1)
            .width(of: rateTextField)

        // Call this to prevent color changing when becoming first responder
        rateTextField.isFirstResponder ? highlightRateTextField() : unhighlightRateTextField()
    }

    @objc
    private func didChangeDescription() {
        layoutRateTextField()
    }

    @objc
    private func editingDidBegin() {
        highlightRateTextField()
    }

    @objc
    private func editingDidEnd() {
        unhighlightRateTextField()
        rateTextField.isEnabled = false
    }

    private func highlightRateTextField() {
        rateTextFieldUnderlineView.backgroundColor = .blue
    }

    private func unhighlightRateTextField() {
        rateTextFieldUnderlineView.backgroundColor = .lightGray
    }

}
