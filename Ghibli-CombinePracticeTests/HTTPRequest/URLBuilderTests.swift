//
//  URLBuilderTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/19/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class URLBuilderTests: XCTestCase {
    
    func testCreateURL() {
        let path = "any-path-\(String.random())"
        let sut = GhibliURLBuilder(path: path).createURL()
        XCTAssertEqual(sut?.scheme, "https")
        XCTAssertEqual(sut?.host(), "ghibliapi.vercel.app")
        XCTAssertEqual(sut?.path(), "/\(path)")
    }
    
}
