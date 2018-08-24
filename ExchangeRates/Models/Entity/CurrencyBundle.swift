//
//  CurrencyBundle.swift
//  ExchangeRates
//
//  22/08/2018.
//

import Foundation

final class CurrencyBundle {

    // MARK: - Properties

    var formattedValue: String = ""
    var value: Double? {
        didSet {
            handleValueUpdate()
        }
    }

    var code: String {
        return currency.code
    }
    var name: String? {
        return currency.name
    }

    private var currency: Currency

    // MARK: - Initialization and deinitialization

    init(currency: Currency, value: Double?) {
        self.currency = currency
        self.value = value
        handleValueUpdate()
    }

    // MARK: - Private methods

    private func handleValueUpdate() {
        guard let value = value else {
            self.formattedValue = ""
            return
        }
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            self.formattedValue = String(format: "%.0f", value)
        } else {
            self.formattedValue = NumberFormatter.currencyFormatter.string(from: NSNumber(value: value)) ?? ""
        }
    }

}

// MARK: - Hashable

extension CurrencyBundle: Hashable {

    var hashValue: Int {
        return code.hashValue
    }

}

// MARK: - Equatable

extension CurrencyBundle: Equatable {

    static func == (lhs: CurrencyBundle, rhs: CurrencyBundle) -> Bool {
        return lhs.code == rhs.code
    }

}
