//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Gimabelle Garcia vasquez on 28/3/23.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}



struct CoinManager {
    
  //  let coinManager = CoinManager()
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "F922608C-5735-4242-B74F-3F8BD33C0971"
    
   
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

        returnUrl(with: urlString) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let bitcoinPrice = self.parseJSON(safeData) {
                    let priceString = String(format: "%.2f", bitcoinPrice)
                    self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                }
            }
        }
        
    }
    
    func returnUrl(with url: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
               completionHandler(data, response, error)
            }
            task.resume()
        }
    }
    
    
    func parseJSON(_ data: Data) -> Double? {
           
           let decoder = JSONDecoder()
           do {
               let decodedData = try decoder.decode(CoinData.self, from: data)
               let lastPrice = decodedData.rate
               print(lastPrice)
               return lastPrice
               
           } catch {
               delegate?.didFailWithError(error: error)
               return nil
           }
       }
    
    
}

