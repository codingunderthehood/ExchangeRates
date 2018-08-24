//
//  RatesConverter.swift
//  ExchangeRates
//
//  24/08/2018.
//

import Foundation

final class RatesConverter {

    func convertToCurrency(rate: Rate, amount: Double) -> CurrencyBundle {
        return CurrencyBundle(currency: rate.targetCurrency, value: amount * rate.value)
    }

    func convertToCurrencies(rates: [Rate], amount: Double) -> [CurrencyBundle] {
        return rates.map { self.convertToCurrency(rate: $0, amount: amount) }
    }

}
