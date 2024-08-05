//
//  Film.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/19/24.
//

import Foundation

struct FilmResponse: Decodable, Equatable {
    let id: String
    let title: String
    let originalTitle: String
    let image: String
    let description: String
    let releaseDate: String
    let runningTime: String
    let rtScore: String
    let people: [String]
    
    func toFilms() -> Film {
        .init(
            id: self.id,
            title: self.title,
            originalTitle: self.originalTitle,
            image: {
                let url = urlWithScheme(self.image)
                return !(url?.path().isEmpty ?? false) ? url : nil
            }(),
            description: self.description,
            releaseDate: self.releaseDate,
            runningTime: GhibliTime.toHourMinute(Int(self.runningTime)),
            rtScore: {
                guard let integerValue = Int(self.rtScore) else { return "NA" }
                return String(integerValue) + "%"
            }(),
            people: self.people
                .compactMap { urlWithScheme($0)?.path() }
                .filter { !$0.isEmpty }
        )
    }
    
    private func urlWithScheme(_ urlString: String) -> URL? {
        guard let url = URL(string: urlString),
              let urlWithScheme = url.withScheme()
        else { return nil }
        
        return urlWithScheme
    }
}

struct Film: Equatable {
    let id: String
    let title: String
    let originalTitle: String
    let image: URL?
    let description: String
    let releaseDate: String
    let runningTime: String
    let rtScore: String
    let people: [String]
}

private extension URL {
    func withScheme() -> Self? {
        scheme == nil ? URL(string: "https://\(absoluteString)") : self
    }
}
