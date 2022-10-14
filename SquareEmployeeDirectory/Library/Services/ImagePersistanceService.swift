//
//  ImagePersistanceService.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-14.
//

import UIKit


class ImagePersistanceService {
    
    
    // MARK: - Private Properties
    
    private let documentsDirectory: URL
    
    
    // MARK: - Init
    
    init() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not find default documents directory")
        }
        
        self.documentsDirectory = documentsDirectory
    }
    
    
    // MARK: - Public Methods
    
    @discardableResult
    func saveImage(_ image: UIImage, url: URL) -> Bool {
        guard let imageData = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        
        let fileName = imageFileName(for: url)
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return true
        } catch {
            print("""
                  Failed to save image from url: \(url) \
                  with fileName: \(fileName), \
                  error: \(error.localizedDescription)
                  """)
            return false
        }
    }
    
    func loadImageFrom(for url: URL) -> UIImage? {
        let fileName = imageFileName(for: url)
        let imagePath = URL(fileURLWithPath: documentsDirectory.absoluteString).appendingPathComponent(fileName).path
        
        return UIImage(contentsOfFile: imagePath)
    }
    
    
    // MARK: - Private Methods
    
    private func imageFileName(for url: URL) -> String {
        url.absoluteString.components(separatedBy: "/").suffix(2).joined(separator: "-")
    }
    
}
