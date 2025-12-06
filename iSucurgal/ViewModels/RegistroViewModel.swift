//
//  RegistroViewModel.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

import Foundation
import Combine
import Foundation

@MainActor
final class RegistroViewModel: ObservableObject {

    @Published var registros: [Registro] = []
    @Published var errorMessage: String?

    private let service = RegistroService()

    func cargar() {
        do {
            registros = try service.getHistorial()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func registrarEntrada(sucursalID: UUID) {
        do {
            try service.crearRegistro(sucursalID: sucursalID, tipo: .entrada)
            cargar()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func registrarSalida(sucursalID: UUID) {
        do {
            try service.crearRegistro(sucursalID: sucursalID, tipo: .salida)
            cargar()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
