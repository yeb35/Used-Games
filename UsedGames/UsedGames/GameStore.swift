//
//  GameStore.swift
//  UsedGames
//
//  Created by Yunus Emre BOLGÖNÜL on 19.05.2023.
//

import UIKit

class GameStore: ObservableObject {
    
    @Published var games: [Game] = []
    //  @Published ile aynı işlem her değişikliği yapmak için @publisher ı klullandık
    //      {
    //        didSet{
    //            objectWillChange.send()
    //        }
    //    }
    //
    
    init(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveChanges),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveChanges),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
        do{
            let data = try Data(contentsOf: gameFileURL)
            let decoder = PropertyListDecoder()
            let games = try decoder.decode([Game].self, from: data)
            
            self.games = games
        }catch{
            print(error)
        }
        //        for _ in 0..<5{
        //            createGame()
    }
    @discardableResult func createGame() -> Game {
        
        let game = Game(random: true)
        
        games.append(game)
        return game
    }
    
    func delete(at indexSet: IndexSet){
        games.remove(atOffsets: indexSet)
    }
    
    func move(indices: IndexSet, to newOffset: Int){
        games.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func indexSet(for game: Game) -> IndexSet?{
        
        if let firstIndex = games.firstIndex(of: game){
            return IndexSet(integer: firstIndex)
        }else{
            return nil
        }
        
    }
    
    func game(at indexSet: IndexSet) -> Game?{
        
        if let firstIndex = indexSet.first{
            return games[firstIndex]
        }
        return nil
    }
    
    func update(game: Game, newValue: Game){
        if let index = games.firstIndex(of: game){
            games[index] = newValue
        }
    }
    
    @objc func saveChanges(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(games)
            do{
                try data.write(to: gameFileURL)
                print(gameFileURL)
            }catch{
                print("An error occured while saving the path: \(error.localizedDescription)")
            }
        } catch  {
            print("An error occured while encoding: \(error.localizedDescription)")
        }
    }
    let gameFileURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("games.plist")
    }()
}
