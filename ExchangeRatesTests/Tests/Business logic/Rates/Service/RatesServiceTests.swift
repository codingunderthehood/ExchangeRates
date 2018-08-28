//
//  RatesServiceTests.swift
//  ExchangeRatesTests
//
//  29/08/2018.
//

import XCTest
@testable import ExchangeRates

final class RatesServiceTests: XCTestCase {

    // MARK: - Main tests

    func testThatGetRatesHandlesTransportError() {
        // given
        let expectedError: NSError = NSError(domain: "mydom", code: 129, userInfo: ["in": "fo"])
        let service = RatesService(transport: MockTransport(policy: .returnError(error: expectedError)), mapper: RatesMapper())
        // when
        service.getRates(currencyCode: "", onCompleted: { _ in
            // then
            XCTFail()
        }, onError: { error in
            XCTAssert(expectedError == error as NSError)
        })
    }

    func testThatGetRatesHandlesData() {
        // given
        let expectedRates: [Rate] = [Rate(baseCurrency: Currency.default, targetCurrency: Currency.default, value: 1)]
        let service = RatesService(
            transport: MockTransport(policy: .returnData(data: Data())),
            mapper: MockMapper(policy: .returnData(data: expectedRates))
        )
        // when
        service.getRates(currencyCode: "", onCompleted: { rates in
            // then
            XCTAssert(expectedRates.count == rates.count)
            XCTAssert(expectedRates.first?.baseCurrency == rates.first?.baseCurrency)
            XCTAssert(expectedRates.first?.targetCurrency == rates.first?.targetCurrency)
            XCTAssertEqual(expectedRates.first?.value ?? 0, rates.first?.value ?? 1, accuracy: 0.00001)
        }, onError: { error in
            XCTFail()
        })
    }

    func testThatGetRatesHandlesMappingError() {
        // given
        let service = RatesService(transport: MockTransport(policy: .returnData(data: Data())), mapper: RatesMapper())
        // when
        service.getRates(currencyCode: "", onCompleted: { _ in
            // then
            XCTFail()
        }, onError: { error in
            XCTAssert(true)
        })
    }

    // MARK: - Mocks

    private final class MockTransport: Transport {

        enum ResponsePolicy {
            case returnError(error: NSError)
            case returnData(data: Data)
        }

        let policy: ResponsePolicy

        init(policy: ResponsePolicy) {
            self.policy = policy
        }

        func perform(request: URLRequest, onCompleted: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
            switch policy {
            case .returnData(let data):
                onCompleted(data)
            case .returnError(let error):
                onError(error)
            }
        }
    }

    private final class MockMapper: RatesAbstractMapper {

        enum ResponsePolicy {
            case returnError(error: NSError)
            case returnData(data: [Rate])
        }

        let policy: ResponsePolicy

        init(policy: ResponsePolicy) {
            self.policy = policy
        }

        func map(data: Data, currencyCode: String) throws -> [Rate] {
            switch policy {
            case .returnData(let data):
                return data
            case .returnError(let error):
                throw error
            }
        }

    }

}
