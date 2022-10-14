//
//  ImageFetchingService.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-14.
//

import UIKit


class ImageFetchingService {
    
    
    // MARK: - Private Properties
    
    private let imagesCache: NSCache<AnyObject, UIImage> = .init()
    private let utilityQueue: DispatchQueue
    private let imagePersistanceService: ImagePersistanceService
    
    
    // MARK: - Init
    
    init(queue: DispatchQueue = .global(qos: .utility), imagePersistanceService: ImagePersistanceService = .init()) {
        self.utilityQueue = queue
        self.imagePersistanceService = imagePersistanceService
    }
    
    
    // MARK: - Public Methods
    
    func cachedImage(for url: URL) -> UIImage? {
        if let memoryImage = imagesCache.object(forKey: url as AnyObject) {
            return memoryImage
        }
        
        return imagePersistanceService.loadImageFrom(for: url)
    }
    
    func loadImage(at url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = cachedImage(for: url) {
            completion(.success(cachedImage))
            return
        }
        
        utilityQueue.async {
            do {
                let imageData = try Data(contentsOf: url)
                if let image = UIImage(data: imageData) {
                    self.imagesCache.setObject(image, forKey: url as AnyObject)
                    self.imagePersistanceService.saveImage(image, url: url)
                    
                    completion(.success(image))
                } else {
                    let error = NSError(
                        code: 404,
                        localizedDescription: "Failed to process image data"
                    )
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}

private extension NSError {
    convenience init(domain: String = "com.sq-test", code: Int, localizedDescription: String) {
        self.init(
            domain: domain,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: localizedDescription]
        )
    }
}
