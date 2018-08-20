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
        adapter.configure(with: ["1",
                                 "d;kfjalkfkjl asklsa dlklkas ljadsfpas iadsin as",
                                 "3",
                                 "123poqkp mkllkmads pi3 ih12 ibcd; jcs 9her1oincd-9 ehef"]
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

final class RatesTableViewCell: UITableViewCell {

    // MARK: - Subviews

    private let label = UILabel()

    // MARK: - Constants

    static let reuseIdentifier: String = String(describing: RatesTableViewCell.self)

    // MARK: - Initialization and deinitialization

    init() {
        super.init(style: .default, reuseIdentifier: RatesTableViewCell.reuseIdentifier)
        backgroundColor = .white

        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UITableViewCell

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    private func layout() {
        label.pin
            .top(self.pin.safeArea)
            .bottom(self.pin.safeArea)
            .start(self.pin.safeArea)
            .end(self.pin.safeArea)
            .margin(8)
            .sizeToFit(.width)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return CGSize(width: contentView.frame.width, height: label.frame.maxY + 8)
    }

    // MARK: - Internal methods

    func configure(with str: String) {
        self.label.text = str
    }

}

import UIKit

final class RatesTableViewAdapter: NSObject {

    // MARK: - Properties

    fileprivate var items: [String] = []

    // MARK: - Internal helpers

    func set(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 36
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // The UITableView will call the cell's sizeThatFit() method to compute the height.
        // WANRING: You must also set the UITableView.estimatedRowHeight for this to work.
        return UITableViewAutomaticDimension
    }

}

// MARK: - UITableViewDelegate

extension RatesTableViewAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
