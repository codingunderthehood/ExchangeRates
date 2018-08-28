//
//  RatesAbstractMapper.swift
//  ExchangeRates
//
//  29/08/2018.
//

import Foundation

protocol RatesAbstractMapper {
    func map(data: Data, currencyCode: String) throws -> [Rate]
}
