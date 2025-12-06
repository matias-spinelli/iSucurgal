//
//  SucursalService.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 05/12/2025.
//

import Foundation

final class SucursalService {
    private let repo = SucursalRepository()
    private let api: APIServiceProtocol

    init(api: APIServiceProtocol = APIServiceMock()) {
        self.api = api
    }

    func importFromJSONResource(bundle: Bundle = .main, resourceName: String = "sucursales", completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            completion(.failure(NSError(domain: "SucursalService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let dtos = try JSONDecoder().decode([SucursalDTO].self, from: data)
            try repo.saveSucursales(dtos)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    func fetchFromAPIAndSave(completion: @escaping (Result<Void, Error>) -> Void) {
        api.fetchSucursales { [weak self] result in
            switch result {
            case .success(let dtos):
                do {
                    try self?.repo.saveSucursales(dtos)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func fetchLocal() throws -> [Sucursal] {
        try repo.getAll()
    }
}
