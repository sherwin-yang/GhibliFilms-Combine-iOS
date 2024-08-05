//
//  FilmTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/19/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class FilmTests: XCTestCase {
    
    func testMap() {
        let peopleEndpointsPath = [makeRandomPath(), makeRandomPath()]
        let filmsDecodable = FilmResponse(
            id: "id-\(Int.random())",
            title: "film-title-\(String.random())",
            originalTitle: "original-title-\(String.random())",
            image: "https://image/\(String.random())",
            description: "description-\(String.random())",
            releaseDate: "release-date-\(String.random())",
            runningTime: String(Int.random()),
            rtScore: String(Int.random()),
            people: [
                "https://people\(peopleEndpointsPath[0])",
                "https://people\(peopleEndpointsPath[1])"
            ]
        )
        
        XCTAssertEqual(
            filmsDecodable.toFilms(),
            Film(
                id: filmsDecodable.id,
                title: filmsDecodable.title,
                originalTitle: filmsDecodable.originalTitle,
                image: URL(string: filmsDecodable.image),
                description: filmsDecodable.description,
                releaseDate: filmsDecodable.releaseDate,
                runningTime: GhibliTime.toHourMinute(Int(filmsDecodable.runningTime)),
                rtScore: filmsDecodable.rtScore + "%",
                people: [peopleEndpointsPath[0], peopleEndpointsPath[1]]
            )
        )
    }
    
    func testMap_shouldHasNilImage() {
        func test(url: String, line: UInt = #line) {
            let filmsDecodable = FilmResponse.sample(image: url)
            
            XCTAssertEqual(filmsDecodable.toFilms().image, nil, line: line)
        }
        
        test(url: "")
        test(url: "www.no-path-url.com")
        test(url: "invalid-url")
    }
    
    func testMap_shouldHasNilRtValue() {
        let filmsDecodable = FilmResponse.sample(rtScore: "not-an-int")
        
        XCTAssertEqual(filmsDecodable.toFilms().rtScore, "NA")
    }
    
    func testMap_somePeopleShouldIncludedOrNot() {
        let peopleEndpointsPath = [makeRandomPath(), makeRandomPath()]
        let filmsDecodable = FilmResponse.sample(people: [
            "https://people\(peopleEndpointsPath[0])",
            "https://people",
            "people\(peopleEndpointsPath[1])",
            "people"
        ])
        
        XCTAssertEqual(
            filmsDecodable.toFilms().people,
            [peopleEndpointsPath[0], peopleEndpointsPath[1]]
        )
    }
}

extension FilmResponse {
    static func sample(
        id: Int = .random(),
        image: String = "https://image/\(String.random())",
        runningTime: String = String(Int.random()),
        rtScore: String = String(Int.random()),
        people: [String] = ["https://people\(String.random() + String(Int.random()))"]
    ) -> Self {
        .init(
            id: "id-\(id)",
            title: "title-\(id)",
            originalTitle: "originalTitle-\(id)",
            image: image,
            description: "description-\(id)",
            releaseDate: "releaseDate-\(id)",
            runningTime: runningTime,
            rtScore: rtScore,
            people: people
        )
    }
}

private func makeRandomPath() -> String {
    "/" + String(Int.random()) + String.random() + String(Int.random())
}
