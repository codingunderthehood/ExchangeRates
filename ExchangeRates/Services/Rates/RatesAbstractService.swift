//
//  RatesAbstractService.swift
//  ExchangeRates
//
//  24/08/2018.
//

protocol RatesAbstractService {
    func getRates(currencyCode: String, onCompleted: @escaping ([Rate]) -> Void, onError: @escaping (Error) -> Void)
}
