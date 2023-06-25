//
//  GameListItem.swift
//  UsedGames
//
//  Created by Yunus Emre BOLGÖNÜL on 24.05.2023.
//

import SwiftUI

struct GameListItem: View {
    
    var game: Game
    
    var numberFormatter: NumberFormatter = Formatters.dollarFormatter
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4.0){
                Text (game.name)
                    .font(.body)
                Text(game.serialNumber)
                    .font(.caption)
                    .foregroundColor(Color(white:0.65))
            }
            Spacer()
            //Text("\(game.priceInDollars)")
            Text(NSNumber(value: game.priceInDollars), formatter: numberFormatter)
                .font(.title2)
                .foregroundColor(game.priceInDollars > 30 ? .blue : .gray)
                .animation(nil)
            
        }
        .padding(.vertical, 6)
    }
}

struct GameListItem_Preview: PreviewProvider{
    static var previews: some View{
        let item = GameListItem(game: Game(random: true))
            .padding(.horizontal)
            .previewLayout(.sizeThatFits)
        Group{
            item
            item
                .preferredColorScheme(.dark)
            item
                .environment(\.sizeCategory, .accessibilityExtraLarge)
            item
                .environment(\.locale, Locale(identifier: "tr"))
        }
    }
}
