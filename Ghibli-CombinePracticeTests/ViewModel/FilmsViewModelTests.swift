//
//  FilmsViewModelTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/19/24.
//

import XCTest
import Combine

@testable import Ghibli_CombinePractice

final class FilmsViewModelTests: XCTestCase {

    func testViewDidLoad() {
        let publisher = PassthroughSubject<[Film], Error>()
        var getFilmsCalled = false
        let sut = FilmsViewModel(getFilms: {
            getFilmsCalled = true
            return publisher.eraseToAnyPublisher()
        })
        
        var films: [Film] = []
        let cancellables = sut.films.sink(receiveValue: { films = $0 })
        defer { cancellables.cancel() }
        
        sut.viewDidLoad()
        
        XCTAssertTrue(getFilmsCalled)
        XCTAssertEqual(films, [])
        
        let filmsSample = [Film.sample(), .sample(), .sample()]
        publisher.send(filmsSample)
        XCTAssertEqual(films, filmsSample)
    }

}
