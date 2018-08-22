//
//  RatesViewState.swift
//  ExchangeRates
//
//  22/08/2018.
//

import Foundation

enum RatesViewState {
    case loading
    case error
    case data(currencies: [CurrencyBundle])
}
