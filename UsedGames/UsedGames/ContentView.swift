import SwiftUI

struct ContentView: View {
    
    @ObservedObject var gameStore = GameStore()
    
    @ObservedObject var imageStore = ImageStore()
    
    
    @State var gameToDelete: Game?
    
    var body: some View {
        
        let list =     List {
            ForEach(gameStore.games) { (game) in
                NavigationLink(destination: DetailView(
                    game: game,
                    gameStore: gameStore,
                    imageStore: imageStore,
                    name: game.name,
                    price: game.priceInDollars,
                    selectedPhoto: imageStore.image(forkey: game.itemKey)
                )
                )  {
                    GameListItem(game: game)
                }
                
            }
            .onDelete { indexSet in
                let gameToDelete = gameStore.game(at: indexSet)
                self.gameToDelete = gameToDelete
                if let gameToDelete = gameToDelete{
                    self.imageStore.deleteImage(forkey: gameToDelete.itemKey)
                }
            }
            .onMove { indices, newOffset in
                gameStore.move(indices: indices, to: newOffset)
            }
        }
            .listStyle(PlainListStyle())
            .navigationTitle("Used Games")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    gameStore.createGame()
                }) {
                    Image(systemName: "plus")
                }
            )
            .navigationBarTitleDisplayMode(.large)
            .actionSheet(item: $gameToDelete) { (game) -> ActionSheet in
                ActionSheet(
                    title: Text("Are you sure?"),
                    message: Text("You will delete \(game.name)"),
                    buttons: [
                        .cancel(),
                        .destructive(Text("Delete")) {
                            if let indexSet = gameStore.indexSet(for: game) {
                                gameStore.delete(at: indexSet)
                            }
                        }
                    ]
                )
            }
        if #available(iOS 16.0, *) {
            NavigationStack {
                list
            }
            .accentColor(.purple)
            
        } else {
            NavigationView{
                list
            }
            .accentColor(.purple)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
