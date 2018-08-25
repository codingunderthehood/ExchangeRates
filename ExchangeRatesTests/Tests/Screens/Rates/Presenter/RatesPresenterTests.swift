//
//  RatesPresenterTests.swift
//  ExchangeRates
//
//  20/08/2018.
//

import XCTest
@testable import ExchangeRates

final class RatesPresenterTest: XCTestCase {

    // MARK: - Constants

    private let defaultSelectedCurrency: CurrencyBundle = CurrencyBundle(currency: Currency.default, value: 1)

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

    func testThatPresenterPassesDataToView() {
        // given
        let amount: Double = 10
        let rate = Rate(baseCurrency: Currency(code: "EUR"), targetCurrency: Currency(code: "EUR"), value: 1)
        let expectedCurrency = RatesConverter().convertToCurrency(rate: rate, amount: amount)
        let service = MockRatesService()
        service.responsePolicy = .returnData(
            data: [rate]
        )
        presenter?.configure(with: service)

        let expectation = self.expectation(description: "Configure calling")
        expectation.expectedFulfillmentCount = 2 // configure with .loading -> configure with .data
        view?.configureExpectation = expectation
        // when
        presenter?.loadData()
        waitForExpectations(timeout: 5, handler: nil)
        // then
        if case .data(currencies: [defaultSelectedCurrency, expectedCurrency])? = view?.lastReceivedState {
            XCTAssert(true)
        } else {
            XCTFail("Expected \(RatesViewState.data(currencies: [defaultSelectedCurrency, expectedCurrency])), got \(String(describing: view?.lastReceivedState))")
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
        waitForExpectations(timeout: 5, handler: nil)

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
        waitForExpectations(timeout: 5, handler: nil)

        // then
        if case .loading? = view?.lastReceivedState {
            XCTAssert(true)
        } else {
            XCTFail("Expected \(RatesViewState.loading), got \(String(describing: view?.lastReceivedState))")
        }
    }

    func testThatChangingAmountUpdatesCurrencies() {
        // given
        let amount: Double = 10
        let rate = Rate(baseCurrency: Currency(code: "EUR"), targetCurrency: Currency(code: "EUR"), value: 1)
        let expectedCurrency = RatesConverter().convertToCurrency(rate: rate, amount: 10)

        let service = MockRatesService()
        service.responsePolicy = .returnData(
            data: [rate]
        )
        presenter?.configure(with: service)

        let expectation = self.expectation(description: "Configure calling")
        expectation.expectedFulfillmentCount = 3 // configure with .loading -> configure with .data -> update with .data
        view?.configureExpectation = expectation

        // when
        presenter?.loadData()
        presenter?.change(amount: String(amount))
        waitForExpectations(timeout: 5, handler: nil)

        // then
        if case .data(currencies: [defaultSelectedCurrency, expectedCurrency])? = view?.lastReceivedState {
            XCTAssert(true)
        } else {
            XCTFail("Expected \(RatesViewState.data(currencies: [defaultSelectedCurrency, expectedCurrency])), got \(String(describing: view?.lastReceivedState))")
        }
    }

    func testThatSelectCurentCurrencyNotCallsForNewRates() {
        // given
        let currencyCode = "EUR"
        let rate = Rate(baseCurrency: Currency(code: currencyCode), targetCurrency: Currency(code: currencyCode), value: 1)

        let service = MockRatesService()
        service.responsePolicy = .returnData(
            data: [rate]
        )
        presenter?.configure(with: service)

        let expectation = self.expectation(description: "Configure calling")
        expectation.expectedFulfillmentCount = 2 // configure with .loading -> configure with .data
        view?.configureExpectation = expectation

        // when
        presenter?.loadData()
        presenter?.select(currency: CurrencyBundle(currency: Currency(code: currencyCode), value: nil))
        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssert(service.currentCurrencyCode == currencyCode, "Expected \(currencyCode), got \(service.currentCurrencyCode)")
        XCTAssert(view?.selectWasCalled == true)
        XCTAssert(service.subscribeOnRatesCallsCount == 1)
    }

    func testThatSelectNewCurrencyCallsForNewRates() {
        // given
        let expectedCurrencyCode = "NewCurrency"
        let rate = Rate(baseCurrency: Currency(code: "EUR"), targetCurrency: Currency(code: "EUR"), value: 1)
        let targetRate = Rate(baseCurrency: Currency(code: "EUR"), targetCurrency: Currency(code: expectedCurrencyCode), value: 1)

        let service = MockRatesService()
        service.responsePolicy = .returnData(
            data: [rate, targetRate]
        )
        presenter?.configure(with: service)

        let expectation = self.expectation(description: "Configure calling")
        expectation.expectedFulfillmentCount = 3 // configure with .loading -> configure with .data -> update with .data
        view?.configureExpectation = expectation

        // when
        presenter?.loadData()
        presenter?.select(currency: CurrencyBundle(currency: Currency(code: expectedCurrencyCode), value: nil))
        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssert(service.currentCurrencyCode == expectedCurrencyCode, "Expected \(expectedCurrencyCode), got \(service.currentCurrencyCode)")
        XCTAssert(view?.selectWasCalled == true)
        XCTAssert(service.subscribeOnRatesCallsCount == 2)
    }

    func testThatChangingAmountChangesCurrenciesAmount() {
        // given
        let updatingAmount: Double = 9
        let rate = Rate(baseCurrency: Currency(code: "EUR"), targetCurrency: Currency(code: "EUR"), value: 1)
        let expectedCurrency = RatesConverter().convertToCurrency(rate: rate, amount: updatingAmount)
        let service = MockRatesService()
        service.responsePolicy = .returnData(
            data: [rate]
        )
        presenter?.configure(with: service)

        let expectation = self.expectation(description: "Configure calling")
        expectation.expectedFulfillmentCount = 3 // configure with .loading -> configure with .data -> update with data
        view?.configureExpectation = expectation

        // when
        presenter?.loadData()
        presenter?.change(amount: String(updatingAmount))
        waitForExpectations(timeout: 5, handler: nil)

        // then
        guard let state = view?.lastReceivedState else {
            XCTFail("Expected \(RatesViewState.data(currencies: [expectedCurrency])), got nil")
            return
        }
        switch state {
        case .data(let currencies):
            XCTAssert(currencies.first?.value == expectedCurrency.value)
            XCTAssert(currencies.first?.formattedValue == expectedCurrency.formattedValue)
        default:
            XCTFail("Expected \(RatesViewState.data(currencies: [expectedCurrency])), got \(String(describing: state))")
        }
    }

    // MARK: - Mocks

    private final class MockRouter: RatesRouterInput {}

    private final class MockViewController: RatesViewInput {

        var lastReceivedState: RatesViewState? = nil
        var configureExpectation: XCTestExpectation?
        var selectWasCalled: Bool = false

        func configure(with state: RatesViewState) {
            guard let expectation = configureExpectation else {
                XCTFail("MockViewController was not setup correctly. Missing XCTExpectation reference")
                return
            }
            lastReceivedState = state
            expectation.fulfill()
        }

        func select(currency: CurrencyBundle) {
            selectWasCalled = true
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
        var currentCurrencyCode: String = ""
        var subscribeOnRatesCallsCount: Int = 0

        func getRates(currencyCode: String, onCompleted: @escaping ([Rate]) -> Void, onError: @escaping (Error) -> Void) {
            subscribeOnRatesCallsCount += 1
            self.currentCurrencyCode = currencyCode
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
