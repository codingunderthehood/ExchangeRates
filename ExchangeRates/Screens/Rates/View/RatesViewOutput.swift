//
//  RatesViewOutput.swift
//  ExchangeRates
//
//  20/08/2018.
//

protocol RatesViewOutput {
    func loadData()
    func select(currency: CurrencyBundle)
    func change(amount: String)
}
