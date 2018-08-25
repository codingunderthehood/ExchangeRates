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
        let router = RatesRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output
        presenter.configure(with: RatesService())

        router.view = view
        view.output = presenter

        return view
    }

}
