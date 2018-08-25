//
//  RatesService.swift
//  ExchangeRates
//
//  24/08/2018.
//

import Foundation

enum BaseServerError: Error {
    case undefind
    case cantMapping
}

final class RatesService: RatesAbstractService {

    private enum Constants {
        static let ratesUpdatingInterval: TimeInterval = 1
    }

    struct SubscribeOnRatesRawResponse: Codable {
        let base, date: String
        let rates: [String: Double]
    }

    func getRates(currencyCode: String, onCompleted: @escaping ([Rate]) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: "https://revolut.duckdns.org/latest?base=\(currencyCode)") else {
            fatalError()
        }
        let request = URLRequest(url: url)
        _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error)
            }

            guard let data = data, response != nil else {
                DispatchQueue.main.async {
                    onError(BaseServerError.undefind)
                }
                return
            }

            let decoder = JSONDecoder()
            do {
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
        }.resume()
    }

}
