//
//  GhibliHTTPRequest.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/19/24.
//

import Foundation

enum HTTPRequestError: Error, Equatable {
    case invalidURL
    case failedToFetch
}

struct GhibliHTTPRequest {
    static func getData(url: URL?) async throws -> Data {
        guard let url = url
        else { throw HTTPRequestError.invalidURL }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else { throw HTTPRequestError.failedToFetch }
        
        return data
    }
}
