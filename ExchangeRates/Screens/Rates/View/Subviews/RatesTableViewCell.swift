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

    private let currencyCodeLabel = UILabel()
    private let currencyNameLabel = UILabel()
    private let rateTextField = UITextField()
    private let rateTextFieldUnderlineView = UIView()

    // MARK: - Constants

    static let reuseIdentifier: String = String(describing: RatesTableViewCell.self)

    private enum Constants {
        static let defaultMargin: CGFloat = 8
    }

    // MARK: - Properties

    var didChangeAmount: StringClosure?

    // MARK: - Initialization and deinitialization

    init() {
        super.init(style: .default, reuseIdentifier: RatesTableViewCell.reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UITableViewCell

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    override func becomeFirstResponder() -> Bool {
        rateTextField.isUserInteractionEnabled = true
        return rateTextField.becomeFirstResponder()
    }

    // MARK: - Internal methods

    func configure(with currency: CurrencyBundle) {
        self.currencyCodeLabel.text = currency.code
        self.currencyNameLabel.text = currency.name
        self.rateTextField.text = currency.formattedValue
    }

    // MARK: - Private methods

    private func setupSubviews() {
        backgroundColor = .white

        currencyCodeLabel.numberOfLines = 1
        currencyCodeLabel.font = UIFont.systemFont(ofSize: 20)
        currencyNameLabel.textColor = .black
        contentView.addSubview(currencyCodeLabel)

        currencyNameLabel.numberOfLines = 1
        currencyNameLabel.font = UIFont.systemFont(ofSize: 14)
        currencyNameLabel.textColor = .gray
        contentView.addSubview(currencyNameLabel)

        rateTextField.font = UIFont.systemFont(ofSize: 20)
        rateTextField.textColor = .black
        rateTextField.keyboardType = .decimalPad
        rateTextField.returnKeyType = .done
        rateTextField.placeholder = "0"
        rateTextField.addTarget(self, action: #selector(didChangeDescription), for: .editingChanged)
        rateTextField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        rateTextField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        rateTextField.textAlignment = .center
        rateTextField.isUserInteractionEnabled = false
        contentView.addSubview(rateTextField)

        rateTextFieldUnderlineView.backgroundColor = .lightGray
        contentView.addSubview(rateTextFieldUnderlineView)
    }

    private func layout() {
        currencyCodeLabel.pin
            .top(contentView.pin.safeArea)
            .start(contentView.pin.safeArea)
            .margin(Constants.defaultMargin)
            .sizeToFit()

        currencyNameLabel.pin
            .below(of: currencyCodeLabel, aligned: .start)
            .bottom(contentView.pin.safeArea)
            .marginStart(0)
            .marginBottom(Constants.defaultMargin)
            .sizeToFit()

        layoutRateTextField()
    }

    private func layoutRateTextField() {
        let maxWidth = contentView.frame.width
            - Constants.defaultMargin * 3
            - max(currencyNameLabel.frame.width, currencyCodeLabel.frame.width)

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
        didChangeAmount?(rateTextField.text ?? "")
    }

    @objc
    private func editingDidBegin() {
        highlightRateTextField()
    }

    @objc
    private func editingDidEnd() {
        unhighlightRateTextField()
        rateTextField.isUserInteractionEnabled = false
    }

    private func highlightRateTextField() {
        rateTextFieldUnderlineView.backgroundColor = .blue
    }

    private func unhighlightRateTextField() {
        rateTextFieldUnderlineView.backgroundColor = .lightGray
    }

}
