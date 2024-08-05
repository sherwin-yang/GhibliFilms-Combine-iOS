//
//  ImageDownloader.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 8/5/24.
//

import UIKit

struct ImageDownloader {
    
    static func download(url: URL?) async -> UIImage? {
        guard let url,
              let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else { return nil }
        
        return UIImage(data: data)
    }
}
