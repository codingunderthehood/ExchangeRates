//
//  RatesTableViewAdapter.swift
//  ExchangeRates
//
//  20/08/2018.
//

import UIKit

final class RatesTableViewAdapter: NSObject {

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
        tableView.estimatedRowHeight = 58
        tableView.register(RatesTableViewCell.self, forCellReuseIdentifier: RatesTableViewCell.reuseIdentifier)
    }

    func configure(with items: [CurrencyBundle]) {
        self.items = items
    }

    func select(item: CurrencyBundle) {
        guard let itemIndex = items.index(of: item) else {
            return
        }
        let firstItemIndexPath = IndexPath(row: 0, section: 0)
        let itemIndexPath = IndexPath(row: itemIndex, section: 0)
        guard firstItemIndexPath != itemIndexPath else {
            return
        }
        tableView?.beginUpdates()
        tableView?.moveRow(at: itemIndexPath, to: firstItemIndexPath)
        tableView?.endUpdates()
        tableView?.scrollToRow(at: firstItemIndexPath, at: .top, animated: true)
        tableView?.cellForRow(at: itemIndexPath)?.becomeFirstResponder()
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

}
