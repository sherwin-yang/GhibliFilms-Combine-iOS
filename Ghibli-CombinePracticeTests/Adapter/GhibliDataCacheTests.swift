//
//  GhibliDataCacheTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/21/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class GhibliDataCacheTests: XCTestCase {
    
    func test_ObjectSaved() async {
        let sut = GhibliDataCache.shared
        let key = "any-key-\(Int.random())"
        
        let oldObject = "any-object-\(Int.random(in: 0...50))" as AnyObject
        await sut.save(object: oldObject, forKey: key)
        
        var currentSavedObject = await sut.get(forKey: key) as? String
        XCTAssertEqual(currentSavedObject, oldObject as? String)
        
        let newObject = "any-key-\(Int.random(in: 51...100))" as AnyObject
        await sut.save(object: newObject, forKey: key)
        
        currentSavedObject = await sut.get(forKey: key) as? String
        XCTAssertEqual(currentSavedObject, newObject as? String)
    }
}
