//
//  RatesPresenter.swift
//  ExchangeRates
//
//  20/08/2018.
//

import Foundation

public extension Double {

    /// SwiftRandom extension
    public static func random(lower: Double = 0, upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }

}

final class RatesMockService: RatesAbstractService {

    private var timer: Timer?

    func getRates(currencyCode: String, onCompleted: @escaping ([Rate]) -> Void, onError: @escaping (Error) -> Void) {
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.1, repeats: true) { _ in
            onCompleted([
                Rate(baseCurrency: Currency(code: currencyCode), targetCurrency: Currency(code: "EUR"), value: Double.random(lower: 1.00, upper: 1.15)),
                Rate(baseCurrency: Currency(code: currencyCode), targetCurrency: Currency(code: "DKK"), value: Double.random(lower: 2.00, upper: 2.11)),
                Rate(baseCurrency: Currency(code: currencyCode), targetCurrency: Currency(code: "RON"), value: Double.random(lower: 2.5000, upper: 2.8000)),
                Rate(baseCurrency: Currency(code: currencyCode), targetCurrency: Currency(code: "HUF"), value: Double.random(lower: 1.5000, upper: 1.7000))
            ])
        }
    }

}

final class RatesPresenter: RatesViewOutput, RatesModuleInput {

    // MARK: - Constants

    private enum Constants {
        static let ratesUpdatingInterval: TimeInterval = 1
    }

    // MARK: - Properties

    weak var view: RatesViewInput?
    var router: RatesRouterInput?
    var output: RatesModuleOutput?
    private var currentAmount: Double = 1
    private var currentCurrencyCode: String = Currency.default.code
    private var service: RatesAbstractService?

    private var rates: [Rate] = []
    private var converter: RatesConverter = RatesConverter()

    // MARK: - RatesViewOutput

    func loadData() {
        view?.configure(with: .loading)
        subscribeOnRatesUpdating()
    }

    func select(currency: CurrencyBundle) {
        guard let index = rates.index(where: { $0.targetCurrency.code == currency.code }), index != 0 else {
            view?.select(currency: currency)
            return
        }
        // Move rate to top
        let rate = rates.remove(at: index)
        rates.insert(rate, at: 0)
        // Select currency in view
        view?.select(currency: currency)
        // Update currency code and amount
        currentCurrencyCode = currency.code
        currentAmount = currency.value ?? 0
    }

    func change(amount: String) {
        self.currentAmount = Double(amount) ?? 0
        // Update view with updated data
        view?.configure(with: .data(currencies: converter.convertToCurrencies(rates: rates, amount: currentAmount)))
    }

    // MARK: - RatesModuleInput

    func configure(with service: RatesAbstractService) {
        self.service = service
    }

    // MARK: - Private methods

    private func subscribeOnRatesUpdating() {
        let newCall = {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + Constants.ratesUpdatingInterval,
                execute: {
                    self.subscribeOnRatesUpdating()
                }
            )
        }

        service?.getRates(currencyCode: currentCurrencyCode, onCompleted: { [weak self] rates in
            guard let `self` = self else {
                return
            }
            // Add selected currency as first rate to pass to a view
            let rateForSelectedCurrency = Rate(
                baseCurrency: Currency(code: self.currentCurrencyCode),
                targetCurrency: Currency(code: self.currentCurrencyCode),
                value: 1
            )
            self.handleRatesUpdating(rates: [rateForSelectedCurrency] + rates)
            newCall()
        }, onError: { [weak self] error in
            self?.view?.configure(with: .error(error: error))
            newCall()
        })
    }

    private func handleRatesUpdating(rates: [Rate]) {
        defer {
            self.view?.configure(
                with: .data(currencies: self.converter.convertToCurrencies(rates: self.rates, amount: self.currentAmount))
            )
        }

        guard !self.rates.isEmpty else {
            self.rates = rates
            return
        }

        var updatedRates: [Rate] = []
        for rate in self.rates {
            guard let index = rates.index(where: { $0.targetCurrency == rate.targetCurrency }) else {
                continue
            }
            updatedRates.append(rates[index])
        }
        self.rates = updatedRates
    }

}
