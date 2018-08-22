//
//  RatesModuleInput.swift
//  ExchangeRates
//
//  20/08/2018.
//

protocol RatesModuleInput: class {
    func configure(with service: RatesAbstractService)
}
