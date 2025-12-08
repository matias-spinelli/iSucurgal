//
//  RegistroManager.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 07/12/2025.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class RegistroManager: ObservableObject {

    @Published private(set) var currentSucursalID: UUID? = nil

    private let registroViewModel: RegistroViewModel
    private let sucursalesViewModel: SucursalesViewModel

    private let detectionRadius: Double
    private let minInterval: TimeInterval

    private var lastEventDate: Date = .distantPast
    private var sucursalLocations: [(id: UUID, name: String, location: CLLocation)] = []

    init(
        registroViewModel: RegistroViewModel,
        sucursalesViewModel: SucursalesViewModel,
        detectionRadius: Double = 50,
        minInterval: TimeInterval = 10
    ) {
        self.registroViewModel = registroViewModel
        self.sucursalesViewModel = sucursalesViewModel
        self.detectionRadius = detectionRadius
        self.minInterval = minInterval

        rebuildCache()
    }

    func rebuildCache() {
        sucursalLocations = sucursalesViewModel.sucursales.map { sucursal in
            (id: sucursal.id,
             name: sucursal.name,
             location: CLLocation(latitude: sucursal.latitude, longitude: sucursal.longitude))
        }
        print("🗺️ Cache reconstruido: \(sucursalLocations.count) sucursales")
    }

    func processLocation(_ userLocation: CLLocation) {

        print("\n📍 Nueva ubicación:")
        print("   Lat: \(userLocation.coordinate.latitude)")
        print("   Lon: \(userLocation.coordinate.longitude)")
        print("   currentSucursalID (UI) = \(currentSucursalID?.uuidString ?? "NINGUNO")")

        guard !sucursalLocations.isEmpty else {
            print("⚠️ No hay sucursales cargadas → NO se procesa ubicación")
            return
        }

        let now = Date()

        if let insideID = currentSucursalID {
            if let entry = sucursalLocations.first(where: { $0.id == insideID }) {
                let dist = userLocation.distance(from: entry.location)
                print("   ↔️ Distancia a sucursal actual (\(entry.name)): \(Int(dist))m")

                if dist > detectionRadius {
                    print("⬅️ SALIDA registrada de sucursal (estabas en): \(entry.name) (\(insideID))")
                    registroViewModel.registrar(tipo: .salida, sucursalID: insideID)

                    currentSucursalID = nil
                    lastEventDate = now

                    tryRegisterEntryAfterExit(userLocation: userLocation, now: now)
                    return
                } else {
                    print("🟢 Seguís dentro de \(entry.name). No se registra nada.")
                    return
                }
            } else {
                print("⚠️ currentSucursalID no encontrada en cache. Reseteo estado interno.")
                currentSucursalID = nil
                lastEventDate = now
            }
        }

        if now.timeIntervalSince(lastEventDate) < minInterval {
            print("⏳ Ignorado por minInterval (\(Int(minInterval))s) para nueva entrada")
            return
        }

        for entry in sucursalLocations {
            let dist = userLocation.distance(from: entry.location)
            print("   ↔️ Distancia a \(entry.name): \(Int(dist))m")
            if dist <= detectionRadius {
                print("➡️ ENTRADA registrada en \(entry.name) (\(entry.id))")
                registroViewModel.registrar(tipo: .entrada, sucursalID: entry.id)
                currentSucursalID = entry.id
                lastEventDate = now
                return
            }
        }

        print("🟡 Fuera de todas y no estabas dentro → Nada que hacer")
    }

    private func tryRegisterEntryAfterExit(userLocation: CLLocation, now: Date) {
        for entry in sucursalLocations {
            let dist = userLocation.distance(from: entry.location)
            print("   (post-salida) ↔️ Distancia a \(entry.name): \(Int(dist))m")
            if dist <= detectionRadius {
                print("➡️ ENTRADA registrada (post-salida) en \(entry.name) (\(entry.id))")
                registroViewModel.registrar(tipo: .entrada, sucursalID: entry.id)
                currentSucursalID = entry.id
                lastEventDate = now
                return
            }
        }
        print("🟡 (post-salida) No hay entrada inmediata en otra sucursal.")
    }
}
