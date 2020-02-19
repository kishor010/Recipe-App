//
//  DirectoryFolder.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 fourtitude. All rights reserved.
//

import Foundation

class DirectoryFolder {
 
    static func getApplicationFolderPath() -> URL? {
        guard let appDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return nil}
        return appDir
    }
    
    static func saveImage(imagePath: String?, imageData: Data?) {
        if let appDir = getApplicationFolderPath(), let data = imageData, let path = imagePath {
            let fileURL = appDir.appendingPathComponent(path)
            
            //Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                } catch let removeError {
                    print("couldn't remove file at path", removeError)
                }
            }
            do {
                try data.write(to: fileURL)
            } catch let error {
                print("error saving file with error", error)
            }
        }
    }
    
    static func deleteRecipeImage(imagePath: String?) {
        if let appDir = getApplicationFolderPath() {
            let fileURL = appDir.appendingPathComponent(imagePath ?? "")
            //Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    debugPrint("Removed old image")
                } catch let removeError {
                    print("couldn't remove file at path", removeError)
                }
            }
        }
    }
}
