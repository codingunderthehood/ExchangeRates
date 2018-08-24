//
//  RatesViewController.swift
//  ExchangeRates
//
//  20/08/2018.
//

import UIKit
import PinLayout

final class RatesViewController: UIViewController, RatesViewInput, ModuleTransitionable {

    // MARK: - Subviews

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()

    // MARK: - Properties

    var output: RatesViewOutput?
    private lazy var adapter = RatesTableViewAdapter()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.loadData()
        adapter.set(tableView: tableView)
        adapter.didChangeAmount = { [weak self] amount in
            self?.output?.change(amount: amount)
        }
        adapter.didSelectCurrency = { [weak self] currency in
            self?.output?.select(currency: currency)
        }
        configureSubviews()
    }

    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSubviews()
    }

    // MARK: - RatesViewInput

    func configure(with state: RatesViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .error:
            activityIndicator.stopAnimating()
        case .data(let currencies):
            activityIndicator.stopAnimating()
            adapter.configure(with: currencies)
        }
    }

    func select(currency: CurrencyBundle) {
        adapter.select(item: currency)
    }

    // MARK: - Private methods

    private func configureSubviews() {
        view.backgroundColor = .white

        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag

        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
    }

    private func layoutSubviews() {
        tableView.pin
            .top(view.pin.safeArea)
            .bottom(view.pin.safeArea)
            .start(view.pin.safeArea)
            .end(view.pin.safeArea)

        activityIndicator.pin
            .center()
    }

}
