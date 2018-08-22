//
//  RatesPresenter.swift
//  ExchangeRates
//
//  20/08/2018.
//

protocol RatesAbstractService {
    func subscribeOnRates(by currency: Currency, onCompleted: ([Rate]) -> Void, onError: (Error) -> Void)
}

final class RatesService: RatesAbstractService {

    func subscribeOnRates(by currency: Currency, onCompleted: ([Rate]) -> Void, onError: (Error) -> Void) {
        onCompleted([
            Rate(baseCurrency: currency, targetCurrency: Currency(code: "USD"), value: 1.36),
            Rate(baseCurrency: currency, targetCurrency: Currency(code: "DKK"), value: 2.07)
        ])
    }

}

class RatesConverter {

    func convertToCurrency(rate: Rate, amount: Double) -> CurrencyBundle {
        return CurrencyBundle(currency: rate.targetCurrency, value: amount * rate.value)
    }

}

final class RatesPresenter: RatesViewOutput, RatesModuleInput {

    // MARK: - Properties

    weak var view: RatesViewInput?
    var router: RatesRouterInput?
    var output: RatesModuleOutput?
    private var service: RatesAbstractService? = RatesService()
    private var converter: RatesConverter = RatesConverter()

    // MARK: - RatesViewOutput

    func loadData() {
        view?.configure(with: .loading)
        service?.subscribeOnRates(by: Currency.default, onCompleted: { rates in
            let currencies = rates.map { converter.convertToCurrency(rate: $0, amount: 1) }
            view?.configure(with: .data(currencies: currencies))
        }, onError: { error in
            view?.configure(with: .error)
        })
    }

    func select(currency: CurrencyBundle) {
        view?.select(currency: currency)
    }

    func change(amount: String) {

    }

    // MARK: - RatesModuleInput

    func configure(with service: RatesAbstractService) {
        self.service = service
    }

}
