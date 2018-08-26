//
//  RatesService.swift
//  ExchangeRates
//
//  24/08/2018.
//

import Foundation

protocol Transport {
    func perform(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

final class URLSessionTransport: Transport {

    func perform(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        _ = URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }

}

final class RatesService: RatesAbstractService {

    // MARK: - Nested types

    private struct SubscribeOnRatesRawResponse: Codable {
        let base, date: String
        let rates: [String: Double]
    }

    // MARK: - Constants

    private let transport: Transport

    // MARK: - Initialization and deinitialization

    init(transport: Transport = URLSessionTransport()) {
        self.transport = transport
    }

    // MARK: - RatesAbstractService

    func getRates(currencyCode: String, onCompleted: @escaping ([Rate]) -> Void, onError: @escaping (Error) -> Void) {
        guard let request = try? RatesServiceRequests.getRates(currencyCode: currencyCode).asURLRequest() else {
            fatalError()
        }

        transport.perform(request: request) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }

            guard let data = data, response != nil else {
                DispatchQueue.main.async {
                    onError(BaseServerError.undefind)
                }
                return
            }

            do {
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
                DispatchQueue.main.async {
                    onCompleted(rates)
                }
            } catch {
                DispatchQueue.main.async {
                    onError(BaseServerError.cantMapping)
                }
                return
            }
        }
    }

}
