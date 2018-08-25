//
//  RatesTableViewAdapterTests.swift
//  ExchangeRatesTests
//
//  25/08/2018.
//

import XCTest
@testable import ExchangeRates

final class RatesTableViewAdapterTests: XCTestCase {

    // MARK: - Properties

    private var table: UITableViewSpy?
    private var adapter: RatesTableViewAdapter?

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        table = UITableViewSpy()
        adapter = RatesTableViewAdapter()
        adapter?.set(tableView: table ?? UITableView())
    }

    override func tearDown() {
        super.tearDown()
        table = nil
        adapter = nil
    }

    // MARK: - Main tests

    func testThatSetTableSetsDelegateAndDataSource() {
        // given
        // when
        adapter?.set(tableView: table ?? UITableView())
        // then
        XCTAssert(table?.delegate is RatesTableViewAdapter)
        XCTAssert(table?.dataSource is RatesTableViewAdapter)
    }

    func testThatFirstConfigureWithItemsReloadsTable() {
        // when
        adapter?.configure(with: [CurrencyBundle(currency: Currency(code: ""), value: nil)])
        // then
        XCTAssert(table?.reloadDataCalls == 1)
    }

    func testThatNotFirstConfigureWithItemsNotReloadsFirstCell() {
        // when
        adapter?.configure(with: [
            CurrencyBundle(currency: Currency(code: ""), value: nil),
            CurrencyBundle(currency: Currency(code: ""), value: nil)
        ])
        adapter?.configure(with: [
            CurrencyBundle(currency: Currency(code: ""), value: nil),
            CurrencyBundle(currency: Currency(code: ""), value: nil)
        ])
        // then
        XCTAssert(table?.lastReloadedIndexPaths != nil)
        XCTAssert(table?.lastReloadedIndexPaths?.isEmpty == false)
        XCTAssert(table?.lastReloadedIndexPaths?.contains(IndexPath(row: 0, section: 0)) == false)
    }

    func testThatSelectNotFirstItemMovesItToTop() {
        // given
        let itemToMove = CurrencyBundle(currency: Currency(code: "2"), value: nil)
        let items = [
            CurrencyBundle(currency: Currency(code: "1"), value: nil),
            itemToMove
        ]
        let expectedMove: (from: IndexPath, to: IndexPath) = (from: IndexPath(row: 1, section: 0), to: IndexPath(row: 0, section: 0))
        // when
        adapter?.configure(with: items)
        adapter?.select(item: itemToMove)
        // then
        guard let lastMove = table?.lastMove else {
            XCTFail()
            return
        }
        XCTAssert(lastMove == expectedMove)
    }

    func testThatSelectFirstItemDoesntMovesIt() {
        // given
        let itemToMove = CurrencyBundle(currency: Currency(code: "1"), value: nil)
        let items = [
            itemToMove,
            CurrencyBundle(currency: Currency(code: "2"), value: nil)
        ]
        // when
        adapter?.configure(with: items)
        adapter?.select(item: itemToMove)
        // then
        XCTAssert(table?.lastMove == nil)
    }

    // MARK: - Mocks

    private final class UITableViewSpy: UITableView {

        var reloadDataCalls: Int = 0
        var lastReloadedIndexPaths: [IndexPath]?
        var lastMove: (from: IndexPath, to: IndexPath)?

        override func reloadData() {
            reloadDataCalls += 1
        }

        override func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
            lastReloadedIndexPaths = indexPaths
        }

        override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
            lastMove = (from: indexPath, to: newIndexPath)
        }

    }

}
