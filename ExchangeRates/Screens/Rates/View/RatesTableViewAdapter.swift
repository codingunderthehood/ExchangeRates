//
//  RatesTableViewAdapter.swift
//  ExchangeRates
//
//  20/08/2018.
//

import UIKit

final class RatesTableViewAdapter: NSObject {

    // MARK: - Properties

    fileprivate var items: [String] = []

    // MARK: - Internal helpers

    func set(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 62
        tableView.keyboardDismissMode = .onDrag
        tableView.register(RatesTableViewCell.self, forCellReuseIdentifier: RatesTableViewCell.reuseIdentifier)
    }

    func configure(with items: [String]) {
        self.items = items
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
        return cell
    }

}

// MARK: - UITableViewDelegate

extension RatesTableViewAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        (tableView.cellForRow(at: indexPath) as? RatesTableViewCell)?.startEditing()
    }

}
