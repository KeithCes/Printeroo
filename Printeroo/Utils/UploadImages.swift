//
//  UploadImages.swift
//  Printeroo
//
//  Created by Admin on 10/8/22.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class UploadImages: NSObject{
    
    static func saveImages(imagesArray : [UIImage], orderPath: String, namesArray: [String]){
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        uploadImages(userId: uid, imagesArray: imagesArray, orderPath: orderPath, namesArray: namesArray) { (uploadedImageUrlsArray) in
            
            print("uploadedImageUrlsArray: \(uploadedImageUrlsArray)")
        }
    }
    
    
    static func uploadImages(userId: String, imagesArray : [UIImage], orderPath: String, namesArray: [String], completionHandler: @escaping ([String]) -> ()){
        
        let storage = Storage.storage()
        
        var uploadedImageUrlsArray = [String]()
        var uploadCount = 0
        let imagesCount = imagesArray.count
        
        for i in 0...imagesArray.count - 1 {
            
            let orderPathFull = orderPath + namesArray[i] + ".png"
            
            let storageRef = storage.reference().child(orderPathFull)
            
            guard let data: Data = imagesArray[i].jpegData(compressionQuality: 0.40) else {
                return
            }
            
            let uploadTask = storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                
                if error != nil{
                    print(error as Any)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    
                    guard let imageUrl = url else {
                        return
                    }
                    
                    uploadedImageUrlsArray.append("\(imageUrl)")
                    uploadCount += 1
                    
                    if uploadCount == imagesCount {
                        NSLog("All Images are uploaded successfully, uploadedImageUrlsArray: \(uploadedImageUrlsArray)")
                        completionHandler(uploadedImageUrlsArray)
                    }
                }
                
            })
            observeUploadTaskFailureCases(uploadTask : uploadTask)
        }
    }
    
    
    static func observeUploadTaskFailureCases(uploadTask : StorageUploadTask){
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    NSLog("File doesn't exist")
                    break
                case .unauthorized:
                    NSLog("User doesn't have permission to access file")
                    break
                case .cancelled:
                    NSLog("User canceled the upload")
                    break
                    
                case .unknown:
                    NSLog("Unknown error occurred, inspect the server response")
                    break
                default:
                    NSLog("A separate error occurred, This is a good place to retry the upload.")
                    break
                }
            }
        }
    }
    
}
