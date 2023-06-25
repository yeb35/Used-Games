//
//  PhotoPicker.swift
//  UsedGames
//
//  Created by Yunus Emre BOLGÖNÜL on 26.05.2023.
//

import UIKit
import SwiftUI
//swiftuı da bütün viewlar struct olarak yani class olarak değil value type olarak tanımlanıyor
struct PhotoPicker: UIViewControllerRepresentable{
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary 
    var imageStore: ImageStore
    var game: Game
    
    @Binding var selectedPhoto: UIImage?
   
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> some UIViewController {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var photoPicker: PhotoPicker
        
        init(_ picker: PhotoPicker) {
            
            self.photoPicker = picker
            super.init()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let selectedPhoto = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
                info[.originalImage] as? UIImage {
                photoPicker.selectedPhoto = selectedPhoto
                if picker.sourceType == .camera{
                    UIImageWriteToSavedPhotosAlbum(selectedPhoto, self, #selector(image(_: error: contextInfo: )), nil)
                }
            //photoPicker.imageStore.setImage(selectedPhoto, forkey: photoPicker.game.itemKey)
                // çekilen fotoğrafı galeriye ekleme                            
            }else{
                photoPicker.selectedPhoto = nil
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        // çekilen fotoğrafı galeriye ekleme
        @objc func image ( _ image: UIImage?, error: Error?, contextInfo: UnsafeRawPointer){
            
        }

    }
}

    
