//
//  RatesServiceRequests.swift
//  ExchangeRates
//
//  27/08/2018.
//

import Foundation

enum RatesServiceRequests: URLRequestConvertible {

    case getRates(currencyCode: String)

    var stringUrl: String {
        switch self {
        case .getRates(let currencyCode):
            return "https://revolut.duckdns.org/latest?base=\(currencyCode)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getRates:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getRates:
            return nil
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getRates:
            return nil
        }
    }

}
