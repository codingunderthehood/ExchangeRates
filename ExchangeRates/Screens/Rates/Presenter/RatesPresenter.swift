//
//  RatesPresenter.swift
//  ExchangeRates
//
//  20/08/2018.
//

final class RatesPresenter: RatesViewOutput, RatesModuleInput {

    // MARK: - Properties

    weak var view: RatesViewInput?
    var router: RatesRouterInput?
    var output: RatesModuleOutput?

    // MARK: - RatesViewOutput

    // MARK: - RatesModuleInput

}
