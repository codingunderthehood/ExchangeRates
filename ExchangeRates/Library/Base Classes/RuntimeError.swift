//
//  RuntimeError.swift
//  ExchangeRates
//
//  27/08/2018.
//

import Foundation

// TODO: Think about naming
struct RuntimeError: LocalizedError {

    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        return message
    }

}
