//
//  Rate.swift
//  ExchangeRates
//
//  22/08/2018.
//

import Foundation

final class Rate {

    var baseCurrency: Currency
    var targetCurrency: Currency
    var value: Double

    init(baseCurrency: Currency, targetCurrency: Currency, value: Double) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.value = value
    }

}
