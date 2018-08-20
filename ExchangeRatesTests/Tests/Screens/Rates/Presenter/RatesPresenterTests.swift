//
//  RatesPresenterTests.swift
//  ExchangeRates
//
//  20/08/2018.
//

import XCTest
@testable import ExchangeRates

final class RatesPresenterTest: XCTestCase {

    // MARK: - Properties

    private var presenter: RatesPresenter?
    private var view: MockViewController?
    private var output: MockModuleOutput?

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        presenter = RatesPresenter()
        presenter?.router = MockRouter()
        view = MockViewController()
        presenter?.view = view
        output = MockModuleOutput()
        presenter?.output = output
    }

    override func tearDown() {
        super.tearDown()
        presenter = nil
        view = nil
    }

    // MARK: - Main tests

    func testThatPresenterHandlesViewLoadedEvent() {
        // when 
        presenter?.viewLoaded()
        // then
        XCTAssertTrue((presenter?.view as? MockViewController)?.setupInitialStateWasCalled == true)
    }

    // MARK: - Mocks

    private final class MockRouter: RatesRouterInput {
    }

    private final class MockViewController: RatesViewInput {
        var setupInitialStateWasCalled: Bool = false

        func setupInitialState() {
            setupInitialStateWasCalled = true
        }
    }

    private final class MockModuleOutput: RatesModuleOutput {

    }

}
