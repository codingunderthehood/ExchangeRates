//
//  RatesMapperTests.swift
//  ExchangeRatesTests
//
//  29/08/2018.
//

import XCTest
@testable import ExchangeRates

final class RatesMapperTests: XCTestCase {

    func testThatMapperCorrectlyMapsData() {
        // given
        let mapper = RatesMapper()
        let base = Currency(code: "EUR")
        guard let data = """
        {
            "base": "EUR",
            "date":"2018-08-28",
            "rates": {
                "AUD":1.5852,
                "BGN":1.9469,
                "BRL":4.7692
            }
        }
        """.data(using: .utf8) else {
            fatalError("Can't create data")
        }
        let expectedRates = [
            Rate(baseCurrency: base, targetCurrency: Currency(code: "AUD"), value: 1.5852),
            Rate(baseCurrency: base, targetCurrency: Currency(code: "BGN"), value: 1.9469),
            Rate(baseCurrency: base, targetCurrency: Currency(code: "BRL"), value: 4.7692)
        ]
        // when
        let mappedRates = try? mapper.map(data: data, currencyCode: base.code)
        // then
        guard let guardedMappedRates = mappedRates else {
            XCTFail()
            return
        }
        XCTAssert(expectedRates.count == guardedMappedRates.count)
        for item in guardedMappedRates {
            guard let index = expectedRates.index(where: { $0.targetCurrency == item.targetCurrency }) else {
                XCTFail()
                return
            }
            XCTAssert(expectedRates[index].baseCurrency == item.baseCurrency)
            XCTAssert(expectedRates[index].targetCurrency == item.targetCurrency)
            XCTAssertEqual(expectedRates[index].value, item.value, accuracy: 0.000001)
        }
    }

    func testThatMapperThrowsErrorOnIncorrectData() {
        // given
        let mapper = RatesMapper()
        let base = Currency(code: "EUR")
        guard let data = """
        {
            "base": "EUR",
            "date":"2018-08-28",
            "rate": {
                "AUD":1.5852,
                "BGN":1.9469,
                "BRL":4.7692
            }
        }
        """.data(using: .utf8) else {
            fatalError("Can't create data")
        }
        // when
        do {
            _ = try mapper.map(data: data, currencyCode: base.code)
            XCTFail()
        } catch {
            XCTAssert(true)
        }

    }

}
