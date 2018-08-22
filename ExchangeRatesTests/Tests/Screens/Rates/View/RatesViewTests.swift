//
//  RatesViewTests.swift
//  ExchangeRates
//
//  20/08/2018.
//

import XCTest
@testable import ExchangeRates

final class RatesViewTests: XCTestCase {

    // MARK: - Properties

    private var view: RatesViewController?
    private var output: RatesViewOutputMock?

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        view = RatesViewController()
        output = RatesViewOutputMock()
        view?.output = output
    }

    override func tearDown() {
        super.tearDown()
        view = nil
        output = nil
    }

    // MARK: - Main tests

    func testThatViewCallsLoadData() {
        // when
        view?.viewDidLoad()
        // then
        XCTAssert(output?.loadDataWasCalled == true)
    }

    // MARK: - Mocks

    final class RatesViewOutputMock: RatesViewOutput {

        var loadDataWasCalled: Bool = false

        func loadData() {
            loadDataWasCalled = true
        }

    }

}
