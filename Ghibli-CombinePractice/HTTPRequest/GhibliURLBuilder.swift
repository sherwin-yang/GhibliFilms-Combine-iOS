//
//  GhibliURLBuilder.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/19/24.
//

import Foundation

struct GhibliURLBuilder {
    private let path: String
    
    init(path: String) {
        self.path = path
    }
    
    func createURL() -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "ghibli.rest"
        component.path = "/\(path)"
        return component.url
    }
}
