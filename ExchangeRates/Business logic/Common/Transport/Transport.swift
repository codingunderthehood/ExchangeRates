//
//  Transport.swift
//  ExchangeRates
//
//  29/08/2018.
//

import Foundation

protocol Transport {
    func perform(request: URLRequest, onCompleted: @escaping (Data) -> Void, onError: @escaping (Error) -> Void)
}
