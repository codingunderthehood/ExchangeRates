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

    func testThatPresenterPassesDataToView() {
        // given
        let service = MockRatesService()
        service.responsePolicy = .returnData(data: [])
        presenter?.configure(with: service)

        let expectation = self.expectation(description: "Configure calling")
        expectation.expectedFulfillmentCount = 2 // configure with .loading -> configure with .data
        view?.configureExpectation = expectation
        // when
        presenter?.loadData()
        waitForExpectations(timeout: 1, handler: nil)
        // then
        if case .data(currencies: [])? = view?.lastReceivedState {
            XCTAssert(true)
        } else {
            XCTFail("Expected \(RatesViewState.data(currencies: [])), got \(String(describing: view?.lastReceivedState))")
        }
    }

    func testThatPresenterPassesErrorToView() {
        // given
        let service = MockRatesService()
        let expectedError: Error = NSError(domain: "myerrordomain", code: 217, userInfo: nil)
        service.responsePolicy = .returnError(error: expectedError)
        presenter?.configure(with: service)

        let expectation = self.expectation(description: "Configure calling")
        expectation.expectedFulfillmentCount = 2 // configure with .loading -> configure with .data
        view?.configureExpectation = expectation
        // when
        presenter?.loadData()
        waitForExpectations(timeout: 1, handler: nil)
        // then
        guard let state = view?.lastReceivedState else {
            XCTFail("Expected \(RatesViewState.error(error: expectedError)), got nil")
            return
        }
        switch state {
        case .error(let error):
            XCTAssert(error as NSError == expectedError as NSError)
        default:
            XCTFail("Expected \(RatesViewState.error(error: expectedError)), got \(String(describing: state))")
        }
    }

    func testThatPresenterCallsLoadingState() {
        // given
        let service = MockRatesService()
        service.responsePolicy = .noReturn
        presenter?.configure(with: service)

        let expectation = self.expectation(description: "Configure calling")
        view?.configureExpectation = expectation
        // when
        presenter?.loadData()
        waitForExpectations(timeout: 1, handler: nil)
        // then
        if case .loading? = view?.lastReceivedState {
            XCTAssert(true)
        } else {
            XCTFail("Expected \(RatesViewState.loading), got \(String(describing: view?.lastReceivedState))")
        }
    }

    // MARK: - Mocks

    private final class MockRouter: RatesRouterInput {
    }

    private final class MockViewController: RatesViewInput {

        var lastReceivedState: RatesViewState? = nil
        var configureExpectation: XCTestExpectation?

        func configure(with state: RatesViewState) {
            guard let expectation = configureExpectation else {
                XCTFail("MockViewController was not setup correctly. Missing XCTExpectation reference")
                return
            }
            lastReceivedState = state
            expectation.fulfill()
        }

        func select(currency: CurrencyBundle) {
        }

    }

    private final class MockModuleOutput: RatesModuleOutput {

    }

    private final class MockRatesService: RatesAbstractService {

        enum ResponsePolicy {
            case returnError(error: Error)
            case returnData(data: [Rate])
            case noReturn
        }

        var responsePolicy: ResponsePolicy = .returnError(error: NSError(domain: "domain", code: 1, userInfo: nil))

        func subscribeOnRates(currencyCode: String, onCompleted: @escaping ([Rate]) -> Void, onError: (Error) -> Void) {
            switch responsePolicy {
            case .returnData(let data):
                onCompleted(data)
            case .returnError(let error):
                onError(error)
            case .noReturn:
                break
            }
        }

    }

}
