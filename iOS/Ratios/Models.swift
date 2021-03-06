//
//  Models.swift
//  Ratios
//
//  Created by Pouria Almassi on 9/5/18.
//  Copyright © 2018 Blockchain Developer. All rights reserved.
//

import Foundation

struct Ratio: Codable {
    let numeratorCoin: Coin
    let denominatorCoin: Coin

    var ratioValueString: String {
        let formatString = (numeratorCoin.id == "bitcoin" || denominatorCoin.id == "bitcoin") ? "%.8f" : "%.2f"
        guard
            let numeratorCoinMarketData = numeratorCoin.marketData,
            let denominatorCoinMarketData = denominatorCoin.marketData,
            denominatorCoinMarketData.currentPrice.usdPrice > 0
            else { return String(format: formatString, 0.0) }
        return String(format: formatString, numeratorCoinMarketData.currentPrice.usdPrice / denominatorCoinMarketData.currentPrice.usdPrice)
    }
}

extension Ratio {
    init(numerator: Coin, denominator: Coin) {
        self.numeratorCoin = numerator
        self.denominatorCoin = denominator
    }
}

extension Ratio: Equatable {
    static func == (lhs: Ratio, rhs: Ratio) -> Bool {
        return lhs.numeratorCoin.id == rhs.numeratorCoin.id &&
            lhs.denominatorCoin.id == rhs.denominatorCoin.id
    }
}

extension Ratio: Hashable {
    var hashValue: Int {
        return numeratorCoin.id.hash ^ denominatorCoin.id.hash
    }
}

struct Coin: Codable {
    let id: String
    let name: String
    let symbol: String
    let marketData: MarketData?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case marketData = "market_data"
    }
}

extension Coin: Hashable {
    var hashValue: Int {
        return id.hash
    }
}

struct MarketData: Codable {
    let currentPrice: CurrentPrice

    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
    }
}

extension MarketData: Hashable { }

struct CurrentPrice: Codable {
    let usdPrice: Double

    enum CodingKeys: String, CodingKey {
        case usdPrice = "usd"
    }
}

extension CurrentPrice: Hashable { }
