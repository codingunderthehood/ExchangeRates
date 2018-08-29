//
//  RatesTableViewAdapter.swift
//  ExchangeRates
//
//  20/08/2018.
//

import UIKit

final class RatesTableViewAdapter: NSObject {

    // MARK: - Constants

    private enum Constants {
        static let rowHeight: CGFloat = 58
    }

    // MARK: - Properties

    private var items: [CurrencyBundle] = []
    private var tableView: UITableView?

    var didSelectCurrency: ((CurrencyBundle) -> Void)?
    var didChangeAmount: StringClosure?

    // MARK: - Internal helpers

    func set(tableView: UITableView) {
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.register(RatesTableViewCell.self, forCellReuseIdentifier: RatesTableViewCell.reuseIdentifier)
    }

    func configure(with items: [CurrencyBundle]) {
        // Reload all table cells if there is no cell previous
        let isNeedReloadAll = self.items.isEmpty
        self.items = items

        if isNeedReloadAll {
            tableView?.reloadData()
        } else {
            // Update from 1 to end
            let indexPathsToUpdate = (1..<items.count).map { IndexPath(row: $0, section: 0) }
            UIView.performWithoutAnimation {
                self.tableView?.reloadRows(at: indexPathsToUpdate, with: .none)
            }
        }

        self.items = items
    }

    func select(item: CurrencyBundle) {
        defer {
            tableView?.cellForRow(at: IndexPath(row: 0, section: 0))?.becomeFirstResponder()
        }

        guard let itemIndex = items.index(of: item), itemIndex != 0 else {
            return
        }

        moveItemTopTopInTable(itemIndex: IndexPath(row: itemIndex, section: 0))
    }

    // MARK: - Private methods

    private func moveItemTopTopInTable(itemIndex: IndexPath) {
        let firstItemIndexPath = IndexPath(row: 0, section: 0)
        tableView?.beginUpdates()
        tableView?.moveRow(at: itemIndex, to: firstItemIndexPath)
        tableView?.endUpdates()
        tableView?.scrollToRow(at: firstItemIndexPath, at: .top, animated: true)
    }

}

// MARK: - UITableViewDataSource

extension RatesTableViewAdapter: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RatesTableViewCell()
        cell.configure(with: items[indexPath.row])
        cell.didChangeAmount = { [weak self] amount in
            self?.didChangeAmount?(amount)
        }
        return cell
    }

}

// MARK: - UITableViewDelegate

extension RatesTableViewAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectCurrency?(items[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }

}
