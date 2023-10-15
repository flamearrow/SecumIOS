//
//  AnyPublisher+Secum.swift
//  Secum
//
//  Created by Chen Cen on 10/15/23.
//

import Foundation
import Combine

extension Publisher {
    func subscribeWithHanlders(
        cancellables: inout Set<AnyCancellable>,
        onError: @escaping (Failure) -> Void,
        onSuccess: @escaping (Output) -> Void
    ) {
        self.sink { receiveCompletion in
            if case .failure(let error) = receiveCompletion {
                onError(error)
            }
        } receiveValue: { value in
            onSuccess(value)
        }.store(in: &cancellables)
    }
}
