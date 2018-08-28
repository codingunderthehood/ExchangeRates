//
//  RatesModuleConfiguratorTests.swift
//  ExchangeRates
//
//  20/08/2018.
//

import XCTest
@testable import ExchangeRates

final class RatesModuleConfiguratorTests: XCTestCase {

	// MARK: - Main tests

    func testThatScreenConfiguresCorrectly() {
        // when
        let viewController = RatesModuleConfigurator().configure()

        // then
        XCTAssertNotNil(viewController.output, "RatesViewController is nil after configuration")
        XCTAssertTrue(viewController.output is RatesPresenter, "output is not RatesPresenter")

        guard let presenter: RatesPresenter = viewController.output as? RatesPresenter else {
            XCTFail("Cannot assign viewController.output as RatesPresenter")
            return
        }

        XCTAssertNotNil(presenter.view, "view in RatesPresenter is nil after configuration")
    }

}
