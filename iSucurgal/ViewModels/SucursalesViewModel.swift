//
//  SucursalesViewModel.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 05/12/2025.
//

import Foundation
import Combine


final class SucursalesViewModel: ObservableObject {
    @MainActor @Published var sucursales: [Sucursal] = []
    @MainActor @Published var isLoading: Bool = false
    @MainActor @Published var errorMessage: String?

    private let service: SucursalService

    init(service: SucursalService = SucursalService()) {
        self.service = service
    }

    func cargarDesdeJSON() {
        isLoading = true
        service.importFromJSONResource { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success:
                    self.cargarDesdeCoreData()
                case .failure(let err):
                    self.errorMessage = "Error importando JSON: \(err.localizedDescription)"
                }
            }
        }
    }

    func traerDesdeAPI() {
        isLoading = true
        service.fetchFromAPIAndSave { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success:
                    self.cargarDesdeCoreData()
                case .failure(let err):
                    self.errorMessage = "Error API: \(err.localizedDescription)"
                }
            }
        }
    }

    func cargarDesdeCoreData() {
        do {
            sucursales = try service.fetchLocal()
        } catch {
            errorMessage = "Error cargando CoreData: \(error.localizedDescription)"
        }
    }
}
