//
//  Currency.swift
//  ExchangeRates
//
//  22/08/2018.
//

import Foundation

final class Currency {

    // MARK: - Constants

    static let `default` = Currency(code: "EUR")

    // MARK: - Properties

    var code: String
    var name: String? {
        return Locale.current.localizedString(forCurrencyCode: code)
    }

    // MARK: - Initialization and deinitialization

    init(code: String) {
        self.code = code
    }

}

// MARK: - Hashable

extension Currency: Hashable {

    var hashValue: Int {
        return code.hashValue
    }

}

// MARK: - Equatable

extension Currency: Equatable {

    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }

}
