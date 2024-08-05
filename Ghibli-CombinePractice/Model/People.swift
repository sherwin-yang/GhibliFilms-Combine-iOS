//
//  People.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/19/24.
//

import Foundation

struct PeopleResponse: Codable, Equatable {
    let id: String
    let name: String
    let films: [String]
    
    func toPeople() -> People {
        .init(name: name, films: films)
    }
}

struct People: Equatable {
    let name: String
    let films: [String]
}
