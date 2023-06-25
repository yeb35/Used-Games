//
//  ImageStore.swift
//  UsedGames
//
//  Created by Yunus Emre BOLGÖNÜL on 27.05.2023.
//

import UIKit

class ImageStore: ObservableObject{
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forkey key: String){
        cache.setObject(image, forKey: key as NSString)
        let data = image.jpegData(compressionQuality: 0.8)
        try? data?.write(to: gameImageURL(forKey: key))
        
        objectWillChange.send()
    }
    
    func image(forkey key: String) -> UIImage?{
        
        if let cahcedObject = cache.object(forKey: key as NSString){
            return cahcedObject
        }
        do{
            
           let imageData = try Data(contentsOf: gameImageURL(forKey: key))
                let image = UIImage(data: imageData)
            
            return image
        }catch{
            print("error retreving image:\(error.localizedDescription)")
        }
        return nil
    }
    
    func deleteImage(forkey key: String ){
        cache.removeObject(forKey: key as NSString)
        try? FileManager.default.removeItem(at: gameImageURL(forKey: key))
        objectWillChange.send()
    }
    
    func gameImageURL (forKey key: String) -> URL{
        let documentDirectories = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
}


