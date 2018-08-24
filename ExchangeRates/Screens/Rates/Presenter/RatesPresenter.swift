//
//  RatesPresenter.swift
//  ExchangeRates
//
//  20/08/2018.
//

import Foundation

protocol RatesAbstractService {
    func subscribeOnRates(by currency: Currency, onCompleted: @escaping  ([Rate]) -> Void, onError: (Error) -> Void)
}

public extension Double {
    /// SwiftRandom extension
    public static func random(lower: Double = 0, upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

final class RatesService: RatesAbstractService {

    private var timer: Timer?

    func subscribeOnRates(by currency: Currency, onCompleted: @escaping ([Rate]) -> Void, onError: (Error) -> Void) {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.1, repeats: true) { _ in
            onCompleted([
                Rate(baseCurrency: currency, targetCurrency: Currency(code: "EUR"), value: Double.random(lower: 1.00, upper: 1.15)),
                Rate(baseCurrency: currency, targetCurrency: Currency(code: "DKK"), value: Double.random(lower: 2.00, upper: 2.11)),
                Rate(baseCurrency: currency, targetCurrency: Currency(code: "RON"), value: Double.random(lower: 2.5000, upper: 2.8000)),
                Rate(baseCurrency: currency, targetCurrency: Currency(code: "HUF"), value: Double.random(lower: 1.5000, upper: 1.7000))
            ])
        }
    }

}

class RatesConverter {

    func convertToCurrency(rate: Rate, amount: Double) -> CurrencyBundle {
        return CurrencyBundle(currency: rate.targetCurrency, value: amount * rate.value)
    }

    func convertToCurrencies(rates: [Rate], amount: Double) -> [CurrencyBundle] {
        return rates.map { self.convertToCurrency(rate: $0, amount: amount) }
    }

}

final class RatesPresenter: RatesViewOutput, RatesModuleInput {

    // MARK: - Properties

    weak var view: RatesViewInput?
    var router: RatesRouterInput?
    var output: RatesModuleOutput?
    private var currentAmount: Double = 1
    private var service: RatesAbstractService? = RatesService()

    private var rates: [Rate] = []
    private var converter: RatesConverter = RatesConverter()

    // MARK: - RatesViewOutput

    func loadData() {
        view?.configure(with: .loading)
        service?.subscribeOnRates(by: Currency.default, onCompleted: { [weak self] rates in
            guard let `self` = self else {
                return
            }
            self.rates = rates
            self.view?.configure(
                with: .data(currencies: self.converter.convertToCurrencies(rates: rates, amount: self.currentAmount))
            )
        }, onError: { [weak self] error in
            self?.view?.configure(with: .error)
        })
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
    }

    func change(amount: String) {
        self.currentAmount = Double(amount) ?? 0
        view?.configure(with: .data(currencies: converter.convertToCurrencies(rates: rates, amount: currentAmount)))
    }

    // MARK: - RatesModuleInput

    func configure(with service: RatesAbstractService) {
        self.service = service
    }

}
