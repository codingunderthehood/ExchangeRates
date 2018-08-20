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

    // MARK: - Properties

    var output: RatesViewOutput?
    private lazy var adapter = RatesTableViewAdapter()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        adapter.set(tableView: tableView)
        adapter.configure(with: ["GBP",
                                 "EUR",
                                 "USD",
                                 "AUD"]
        )
        tableView.reloadData()
    }

    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin
            .top(view.pin.safeArea)
            .bottom(view.pin.safeArea)
            .start(view.pin.safeArea)
            .end(view.pin.safeArea)
    }

    // MARK: - RatesViewInput

}
