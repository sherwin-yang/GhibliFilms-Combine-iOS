//
//  FilmDetailViewModelTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/27/24.
//

import XCTest
import Combine

@testable import Ghibli_CombinePractice

final class FilmDetailViewModelTests: XCTestCase {

    func testViewDidLoad_shouldCallGetPeople_withFilmId() {
        var passedFilmId: String?
        let sut = FilmDetailViewModel(
            getPeople: {
                passedFilmId = $0
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
        )
        sut.film = .sample(id: "any-id-\(Int.random())")
        
        sut.viewDidLoad()
        
        XCTAssertEqual(passedFilmId, sut.film?.id)
    }
    
    func testViewDidLoad_shouldNotCallGetPeople_whenFilmIsNotSet() {
        var getPeopleCalled = false
        let sut = FilmDetailViewModel(
            getPeople: { _ in
                getPeopleCalled = true
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
        )
        
        sut.viewDidLoad()
        
        XCTAssertFalse(getPeopleCalled)
    }
    
    func testViewDidLoad_publishPeople_whenPeopleReceived() {
        let peoplePublisher = PassthroughSubject<[People], Error>()
        let sut = FilmDetailViewModel(
            getPeople: { _ in
                peoplePublisher.eraseToAnyPublisher()
            }
        )
        sut.film = .sample()
        
        sut.viewDidLoad()
        
        var result: [People] = []
        let cancellable = sut.people.sink(
            receiveCompletion: { _ in },
            receiveValue: {
                result = $0
            }
        )
        defer { cancellable.cancel() }
        
        XCTAssertTrue(result.isEmpty)
        
        let people: [People] = [
            .init(name: "any-name-\(String.random())",
                  films: ["any-film-\(String.random())"]),
            .init(name: "any-name-\(String.random())",
                  films: ["any-film-\(String.random())"])
        ]
        peoplePublisher.send(people)
        
        XCTAssertEqual(result, people)
    }
}
