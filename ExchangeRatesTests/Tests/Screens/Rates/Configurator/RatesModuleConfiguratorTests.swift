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

    func testThatViewControllerLoadsCorrectly() {
        if UIStoryboard(name: String(describing: RatesViewController.self),
                        bundle: Bundle.main).instantiateInitialViewController() == nil {
            XCTFail("Can't load RatesViewController from storyboard, check that controller is initial view controller")
        }
    }

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
        XCTAssertNotNil(presenter.router, "router in RatesPresenter is nil after configuration")
        XCTAssertTrue(presenter.router is RatesRouter, "router is not RatesRouter")

        guard let router: RatesRouter = presenter.router as? RatesRouter else {
            XCTFail("Cannot assign presenter.router as RatesRouter")
            return
        }

        XCTAssertTrue(router.view is RatesViewController, "view in router is not RatesViewController")
    }

}
