//
//  ImageDownloaderIntegrationTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 8/5/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class ImageDownloaderIntegrationTests: XCTestCase {

    func testDownloadSuccess() async {
        let image = await ImageDownloader.download(
            url: URL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/npOnzAbLh6VOIu3naU5QaEcTepo.jpg")
        )
        
        XCTAssertNotNil(image)
    }
    
    func testDownloadFail() async {
        let image = await ImageDownloader.download(
            url: URL(string: "non-existing-image")
        )
        
        XCTAssertNil(image)
    }

}
