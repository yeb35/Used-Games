//
//  Game.swift
//  UsedGames
//
//  Created by Yunus Emre BOLGÖNÜL on 8.05.2023.
//
import Foundation

class Game: NSObject, Identifiable, Codable {
    
    var name: String
    var priceInDollars: Double
    var serialNumber: String
    var dateCreated: Date
    let itemKey: String
    
    
    
    init(name: String, priceInDollars: Double, serialNumber: String) {
        self.name = name
        self.priceInDollars = priceInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
    }
    
    convenience init(random: Bool = false) {
        if random {
            let conditions = ["New", "Mint", "Used"]
            let randomCondition = conditions.randomElement() ?? ""
            
            let names = ["Resident Evil", "Gears of War", "Halo", "God of War"]
            
            let randomName = names.randomElement() ?? ""
            
            let randomTitle = "\(randomCondition) \(randomName) \(Int.random(in: 0...5))"
            
            let serialNumber = UUID().uuidString.components(separatedBy: "-").first ?? ""
            
            let priceInDollars = Double.random(in: 0...69)
            
            self.init(name: randomTitle, priceInDollars: priceInDollars, serialNumber: serialNumber)
        } else {
            self.init(name: "", priceInDollars: 0, serialNumber: "")
        }
    }
}
