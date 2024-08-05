//
//  GhibliTimeTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/19/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class GhibliTimeTests: XCTestCase {
    
    func testToHourMinute() {
        XCTAssertEqual(GhibliTime.toHourMinute(nil), "NA")
        XCTAssertEqual(GhibliTime.toHourMinute(60), "1h, 0m")
        XCTAssertEqual(GhibliTime.toHourMinute(75), "1h, 15m")
        XCTAssertEqual(GhibliTime.toHourMinute(120), "2h, 0m")
        XCTAssertEqual(GhibliTime.toHourMinute(125), "2h, 5m")
    }
    
}
