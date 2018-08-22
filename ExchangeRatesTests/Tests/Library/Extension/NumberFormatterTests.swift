//
//  NumberFormatterTests.swift
//  ExchangeRatesTests
//
//  22/08/2018.
//

import XCTest
@testable import ExchangeRates

final class NumberFormatterTests: XCTestCase {

    // MARK: - Main tests

    func testThatAfterFormattingNumberOfDecimalDigitsIsEqualTwo() {
        // given
        let value: NSNumber = 1.0012
        let expectedResult: String = "1.00"
        // when
        let result = NumberFormatter.currencyFormatter.string(from: value) ?? ""
        // then
        XCTAssert(result == expectedResult, "\(result) != \(expectedResult)")

    }

}
