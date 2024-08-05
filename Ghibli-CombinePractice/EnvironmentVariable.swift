//
//  EnvironmentVariable.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/20/24.
//

import Foundation

struct EnvironmentVariable {
    static var isUnitTest: Bool {
        let bundleKeyPath = envVar(key: "XCTestBundlePath") ?? ""
        return bundleKeyPath.hasSuffix("Ghibli-CombinePracticeTests.xctest")
    }
    
    private static func envVar(key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }
}
