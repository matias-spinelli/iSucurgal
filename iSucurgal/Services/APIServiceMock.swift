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
        guard let url = bundle.url(forResource: "sucursales", withExtension: "json") else {
            completion(.failure(NSError(domain: "APIServiceMock", code: 1, userInfo: [NSLocalizedDescriptionKey: "sucursales.json not found"])))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let list = try JSONDecoder().decode([SucursalDTO].self, from: data)
            completion(.success(list))
        } catch {
            completion(.failure(error))
        }
    }
}
