//
//  RatesConverterTests.swift
//  ExchangeRatesTests
//
//  24/08/2018.
//

import XCTest
@testable import ExchangeRates

final class RatesConverterTests: XCTestCase {

    func testThatRateConvertsCorrectlyToCurrencyBundle() {
        // given
        let converter = RatesConverter()
        let rate = Rate(baseCurrency: Currency(code: "base"), targetCurrency: Currency(code: "target"), value: 70)
        let amount: Double = 2
        let expectedCurrency = CurrencyBundle(currency: Currency(code: "target"), value: rate.value * amount)
        // when
        let currency = converter.convertToCurrency(rate: rate, amount: 2)
        // then
        XCTAssert(expectedCurrency.value == currency.value)
        XCTAssert(expectedCurrency.code == currency.code)
    }

}
