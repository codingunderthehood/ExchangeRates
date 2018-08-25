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

    func subscribeOnRates(currencyCode: String, onCompleted: @escaping ([Rate]) -> Void, onError: (Error) -> Void) {
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

    // MARK: - Properties

    weak var view: RatesViewInput?
    var router: RatesRouterInput?
    var output: RatesModuleOutput?
    private var currentAmount: Double = 1
    private var currentCurrencyCode: String = Currency.default.code
    private var service: RatesAbstractService? = RatesMockService()

    private var rates: [Rate] = []
    private var converter: RatesConverter = RatesConverter()

    // MARK: - RatesViewOutput

    func loadData() {
        view?.configure(with: .loading)
        subscribeOnRatesUpdating(currencyCode: currentCurrencyCode)
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
        // Subscribe to new currency
        currentCurrencyCode = currency.code
        subscribeOnRatesUpdating(currencyCode: currentCurrencyCode)
    }

    func change(amount: String) {
        self.currentAmount = Double(amount) ?? 0
        view?.configure(with: .data(currencies: converter.convertToCurrencies(rates: rates, amount: currentAmount)))
    }

    // MARK: - RatesModuleInput

    func configure(with service: RatesAbstractService) {
        self.service = service
    }

    // MARK: - Private methods

    private func subscribeOnRatesUpdating(currencyCode: String) {
        service?.subscribeOnRates(currencyCode: currencyCode, onCompleted: { [weak self] rates in
            self?.handleRatesUpdating(rates: rates)
        }, onError: { [weak self] error in
            self?.view?.configure(with: .error(error: error))
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
