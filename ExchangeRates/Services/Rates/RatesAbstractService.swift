//
//  RatesAbstractService.swift
//  ExchangeRates
//
//  24/08/2018.
//

protocol RatesAbstractService {
    func subscribeOnRates(currencyCode: String, onCompleted: @escaping  ([Rate]) -> Void, onError: (Error) -> Void)
}
