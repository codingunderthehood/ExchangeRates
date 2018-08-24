//
//  RatesViewState.swift
//  ExchangeRates
//
//  22/08/2018.
//

import Foundation

enum RatesViewState {
    case loading
    case error(error: Error)
    case data(currencies: [CurrencyBundle])
}
