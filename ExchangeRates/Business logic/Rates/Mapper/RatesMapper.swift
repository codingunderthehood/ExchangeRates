//
//  RatesMapper.swift
//  ExchangeRates
//
//  29/08/2018.
//

import Foundation

final class RatesMapper: RatesAbstractMapper {

    // MARK: - Nested types

    private struct SubscribeOnRatesRawResponse: Codable {
        let base, date: String
        let rates: [String: Double]
    }

    // MARK: - Internal methods

    func map(data: Data, currencyCode: String) throws -> [Rate] {
        let decoder = JSONDecoder()
        let serverResponse = try decoder.decode(SubscribeOnRatesRawResponse.self, from: data)
        var rates: [Rate] = []
        for rate in serverResponse.rates {
            let rate = Rate(
                baseCurrency: Currency(code: currencyCode),
                targetCurrency: Currency(code: rate.key),
                value: rate.value
            )
            rates.append(rate)
        }
        return rates
    }

}
