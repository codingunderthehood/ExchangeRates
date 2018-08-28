//
//  Factory.swift
//  ExchangeRates
//
//  29/08/2018.
//

import Foundation

protocol Factory {

    associatedtype Output

    func produce() -> Output

}
