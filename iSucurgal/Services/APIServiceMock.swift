//
//  APIServiceMock.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 05/12/2025.
//

import Foundation

public protocol APIServiceProtocol {
    func fetchSucursales(completion: @escaping (Result<[SucursalDTO], Error>) -> Void)
}

public final class APIServiceMock: APIServiceProtocol {
    private let bundle: Bundle

    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    public func fetchSucursales(completion: @escaping (Result<[SucursalDTO], Error>) -> Void) {
        completion(.success([]))
    }
}
