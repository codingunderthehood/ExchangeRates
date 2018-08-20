//
//  AppDelegate.swift
//  ExchangeRates
//
//  20/08/2018.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        initializeRootView()
        return true
    }

    // MARK: - Private methods

    private func initializeRootView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RatesModuleConfigurator().configure()
        window?.makeKeyAndVisible()
    }

}
