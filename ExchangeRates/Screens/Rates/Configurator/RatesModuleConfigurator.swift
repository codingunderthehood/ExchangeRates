//
//  RatesModuleConfigurator.swift
//  ExchangeRates
//
//  20/08/2018.
//

import UIKit

final class RatesModuleConfigurator {

    // MARK: - Internal methods

    func configure(output: RatesModuleOutput? = nil) -> RatesViewController {
        let view = RatesViewController()
        let presenter = RatesPresenter()

        presenter.view = view
        presenter.output = output
        presenter.configure(with: RatesServiceFactory().produce())

        view.output = presenter

        return view
    }

}
