//
//  ImageDownloaderTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 8/5/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class ImageDownloaderTests: XCTestCase {

    func testDownloadShouldReturnNil() async {
        let result = await ImageDownloader.download(url: nil)
        XCTAssertNil(result)
    }

}
