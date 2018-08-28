//
//  RatesService.swift
//  ExchangeRates
//
//  24/08/2018.
//

import Foundation

final class RatesService: RatesAbstractService {

    // MARK: - Constants

    private let transport: Transport
    private let mapper: RatesAbstractMapper

    // MARK: - Initialization and deinitialization

    init(transport: Transport, mapper: RatesAbstractMapper) {
        self.transport = transport
        self.mapper = mapper
    }

    // MARK: - RatesAbstractService

    func getRates(currencyCode: String, onCompleted: @escaping ([Rate]) -> Void, onError: @escaping (Error) -> Void) {
        guard let request = try? RatesServiceRequests.getRates(currencyCode: currencyCode).asURLRequest() else {
            fatalError()
        }

        transport.perform(request: request, onCompleted: { [weak self] data in
            guard let `self` = self else {
                return
            }
            do {
                let rates = try self.mapper.map(data: data, currencyCode: currencyCode)
                print(rates.count)
                DispatchQueue.main.async {
                    onCompleted(rates)
                }
            } catch {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        }, onError: { error in
            DispatchQueue.main.async {
                onError(error)
            }
        })
    }

}
