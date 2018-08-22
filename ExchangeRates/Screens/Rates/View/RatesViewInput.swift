//
//  RatesViewInput.swift
//  ExchangeRates
//
//  20/08/2018.
//

protocol RatesViewInput: class {
    func configure(with state: RatesViewState)
    func select(currency: CurrencyBundle)
}
