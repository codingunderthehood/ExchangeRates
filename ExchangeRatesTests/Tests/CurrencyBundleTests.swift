//
//  CurrencyBundleTests.swift
//  ExchangeRatesTests
//
//  22/08/2018.
//

import XCTest
@testable import ExchangeRates

final class CurrencyBundleTests: XCTestCase {

    func testThatFormattedValueComputesCorrectly() {
        // given
        let currency = CurrencyBundle(currency: Currency.default, value: 1234.5678)
        let expectedResult = "1234.56"
        // then
        XCTAssert(currency.formattedValue == expectedResult, "\(currency.formattedValue) != \(expectedResult)")
    }

    func testThatFormattedValueUpdatesAfterValueUpdating() {
        // given
        let currency = CurrencyBundle(currency: Currency.default, value: 1234.5678)
        let expectedResult = "7.17"
        // when
        currency.value = 7.17
        // then
        XCTAssert(currency.formattedValue == expectedResult, "\(currency.formattedValue) != \(expectedResult)")
    }

}
