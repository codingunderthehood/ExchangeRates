//
//  URLSessionTransport.swift
//  ExchangeRates
//
//  29/08/2018.
//

import Foundation

final class URLSessionTransport: Transport {

    func perform(request: URLRequest, onCompleted: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        _ = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }

            guard let data = data, response != nil else {
                onError(BaseServerError.undefind)
                return
            }

            onCompleted(data)
        }).resume()
    }

}
