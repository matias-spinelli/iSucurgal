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

    @MainActor
    func cargarSucursales() {
        isLoading = true
        errorMessage = nil

        do {
            let locales = try service.fetchLocal()

            if !locales.isEmpty {
                self.sucursales = locales
                self.isLoading = false
                return
            }

        } catch {
            print("Error cargando CoreData: \(error.localizedDescription)")
        }

        traerDesdeAPI(oSiFallaLuego: cargarDesdeJSON)
    }

    private func traerDesdeAPI(oSiFallaLuego fallback: @escaping () -> Void) {
        service.fetchFromAPIAndSave { [weak self] result in
            Task { @MainActor in
                guard let self else { return }

                switch result {
                case .success:
                    self.cargarDesdeCoreData()
                    self.isLoading = false

                case .failure:
                    print("API falló, fallback al JSON")
                    fallback()
                }
            }
        }
    }

    private func cargarDesdeJSON() {
        service.importFromJSONResource { [weak self] result in
            Task { @MainActor in
                guard let self else { return }

                switch result {
                case .success:
                    self.cargarDesdeCoreData()
                    self.isLoading = false

                case .failure(let err):
                    self.errorMessage = "No hay sucursales disponibles.\n\(err.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

    func cargarDesdeCoreData() {
        do {
            self.sucursales = try service.fetchLocal()

            if self.sucursales.isEmpty {
                self.errorMessage = "No hay sucursales disponibles."
            }

        } catch {
            self.errorMessage = "Error cargando CoreData: \(error.localizedDescription)"
        }
    }
}

extension SucursalesViewModel {
    func nombreDeSucursal(id: UUID) -> String? {
        sucursales.first(where: { $0.id == id })?.name
    }
}
