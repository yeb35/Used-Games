//
//  DetailView.swift
//  UsedGames
//
//  Created by Yunus Emre BOLGÖNÜL on 24.05.2023.
//

import SwiftUI

import Combine

struct DetailView: View {
    var game: Game
    
    var gameStore: GameStore
    
    var imageStore:ImageStore
    
    @State var name: String = ""
    
    @State var price: Double = 0.0
    
    @State var shouldEnableSaveButton: Bool = true
    
    @State var isPhotoPickerPresenting: Bool = false
    @State var isPhotoPickerActionSheetPresenting: Bool = false
    
    @State var selectedPhoto: UIImage?
    
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func validate(){
        
        let isPhotoUpdated = imageStore.image(forkey: game.itemKey) == selectedPhoto
        
        shouldEnableSaveButton = game.name != name || game.priceInDollars != price || isPhotoUpdated
    }
    
    func createActionSheet()-> ActionSheet {
        var buttons: [ ActionSheet.Button] = [
            .cancel()
        ]
        // kamera var mı yok mu
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            buttons.append(.default(Text("Camera"), action: {
                sourceType = .camera
                isPhotoPickerPresenting = true

            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            buttons.append(.default(Text("Photo Library"),
                action: {
                    sourceType = .photoLibrary
                    isPhotoPickerPresenting = true
            }))
        }
        return ActionSheet(
            title: Text("Please select a source."),
            message: nil,
            buttons: buttons)
    }
    var body: some View {
        Form{
            Section{
                VStack(alignment: .leading, spacing: 6.0){
                    foregroundColor(.secondary)
                    Text("Name")
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(name), perform: {
                            newValue in validate()
                        })
                }.padding(.vertical, 4.0)
                
                VStack(alignment: .leading, spacing: 6.0){
                    foregroundColor(.secondary)
                    Text("Price in Dollars")
                    TextField("Price in Dollars", value: $price, formatter: Formatters.dollarFormatter)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(price), perform: {
                            newValue in validate()
                        })
                }.padding(.vertical, 4.0)
            }
            if let selectedPhoto = selectedPhoto{
                
                Section(header: Text("Image")){
                    Image(uiImage: selectedPhoto)
                        .resizable()// resmin boyutunu ekran kadar ayarlama
                        .aspectRatio(contentMode: .fit)// çözünürlüğü koruyarak
                        .padding(.vertical)
                        .overlay(Button(action: {
                            self.selectedPhoto = nil
                            imageStore.deleteImage(forkey: game.itemKey)
                        }, label: {
                            Color.white
                                .frame(width: 40,height: 40)
                            Image(systemName: "trash")
                        }, alignment: .topTrailing
                                       ))
                }
            }
            Section{
                Button(action: {
                    
                    let newGame = Game(name: name, priceInDollars: price, serialNumber: game.serialNumber)
                    
                    gameStore.update(game: game, newValue: newGame)
                    if let selectedPhoto = selectedPhoto{
                        imageStore.setImage(selectedPhoto, forkey: game.itemKey)
                    }
                   
                }, label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50.0)
                })
                .disabled(!shouldEnableSaveButton)
            }
        }
        .toolbar{
            ToolbarItem(placement: .bottomBar){
                Button(action: {
                    
                    if UIImagePickerController.isSourceTypeAvailable(.camera){
                            isPhotoPickerActionSheetPresenting = true
                    }else{
                        isPhotoPickerPresenting = true
                    }
                }, label: {
                    Image(systemName: "camera.fill")
                })
            }
        }.actionSheet(isPresented: $isPhotoPickerActionSheetPresenting, content: {
            createActionSheet()
        })
        .navigationBarTitleDisplayMode(.inline) //  bug bu geçtiğimiz ekranda küçük nav view e geçiyor gibi göüküyor ama geçmyiyor aşağı atıyor.
        
        .sheet(isPresented: $isPhotoPickerPresenting, content: {
            PhotoPicker(sourceType: sourceType,
                        imageStore: imageStore,
                        game:game,
                        selectedPhoto: $selectedPhoto)
            .onReceive(Just(selectedPhoto)){
                newValue in validate()
            }
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let gameStore = GameStore()
        let imageStore = ImageStore()
        let game = gameStore.createGame()
        
        DetailView(game: game, gameStore: gameStore, imageStore: imageStore)
    }
}
