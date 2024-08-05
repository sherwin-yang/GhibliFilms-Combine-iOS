//
//  PeopleTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/26/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class PeopleTests: XCTestCase {

    func testToPeople() {
        let sut = PeopleResponse(
            id: String.random(),
            name: "any-name-\(String.random())",
            films: ["any-film-\(Int.random())",
                    "any-film-\(Int.random())"]
        )
        
        XCTAssertEqual(
            sut.toPeople(), 
            People(name: sut.name, films: sut.films)
        )
    }

}
