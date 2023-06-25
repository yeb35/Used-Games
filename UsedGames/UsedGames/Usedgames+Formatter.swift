//
//  Usedgames+Formatter.swift
//  UsedGames
//
//  Created by Yunus Emre BOLGÖNÜL on 22.05.2023.
//

import Foundation

struct Formatters{
    
    static let dollarFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
