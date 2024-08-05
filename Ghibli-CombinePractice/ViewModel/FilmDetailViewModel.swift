//
//  FilmDetailViewModel.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/27/24.
//

import Foundation
import Combine

final class FilmDetailViewModel {
    
    var film: Film?
    var people = CurrentValueSubject<[People], Never>([])
    
    private let getPeople: (String) -> AnyPublisher<[People], Error>
    private var cancellables = Set<AnyCancellable>()
    
    init(getPeople: @escaping (String) -> AnyPublisher<[People], Error>) {
        self.getPeople = getPeople
    }
    
    func viewDidLoad() {
        guard let filmId = film?.id else { return }
        getPeople(filmId).sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] in
                self?.people.send($0)
            }
        ).store(in: &cancellables)
    }
}

extension FilmDetailViewModel {
    static func make() -> Self {
        .init(
            getPeople: { filmId in
                ConverterToCombine<[People]>.publisher {
                    try await PeopleProvider.make().get(for: filmId)
                }
            }
        )
    }
}
