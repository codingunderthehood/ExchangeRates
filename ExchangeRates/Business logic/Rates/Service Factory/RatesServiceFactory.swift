//
//  RatesServiceFactory.swift
//  ExchangeRates
//
//  29/08/2018.
//

import Foundation

final class RatesServiceFactory: Factory {

    typealias Output = RatesService

    func produce() -> RatesService {
        return RatesService(transport: URLSessionTransport(), mapper: RatesMapper())
    }

}
