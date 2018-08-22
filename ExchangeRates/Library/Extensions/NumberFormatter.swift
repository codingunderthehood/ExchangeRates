//
//  NumberFormatter.swift
//  ExchangeRates
//
//  22/08/2018.
//

import Foundation

extension NumberFormatter {

    /// Formatter for currencies/prices formatting
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .floor
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        formatter.usesGroupingSeparator = false

        return formatter
    }()

}
