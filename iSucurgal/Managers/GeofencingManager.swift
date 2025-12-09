//
//  GeofencingManager.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 08/12/2025.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine
import UIKit

@MainActor
final class GeofencingManager: NSObject, ObservableObject {

    private let manager = CLLocationManager()
    weak var registroManager: RegistroManager?

    @Published var monitoredRegions: [CLCircularRegion] = []

    override init() {
        super.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }

    // MARK: - Configurar geofences

    func setupGeofences(for sucursales: [Sucursal]) {

        guard !sucursales.isEmpty else {
            print("⚠️ No hay sucursales → NO configuro geofences")
            return
        }

        guard manager.authorizationStatus == .authorizedAlways else {
            print("🔴 No tengo AUTH ALWAYS")
            return
        }

        if !manager.monitoredRegions.isEmpty {
            print("♻️ Reseteando geofences → \(manager.monitoredRegions.count) regiones previas")
            for r in manager.monitoredRegions {
                manager.stopMonitoring(for: r)
            }
        }

        monitoredRegions.removeAll()

        for suc in sucursales {
            let center = CLLocationCoordinate2D(
                latitude: suc.latitude,
                longitude: suc.longitude
            )

            let region = CLCircularRegion(
                center: center,
                radius: 80,
                identifier: suc.id.uuidString
            )

            region.notifyOnEntry = true
            region.notifyOnExit = true

            manager.startMonitoring(for: region)
            monitoredRegions.append(region)

            print("🟦 Monitoreando geofence → \(region.identifier)")
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension GeofencingManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("🛂 [GEOFENCE] Authorization: \(manager.authorizationStatus.rawValue)")
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if UIApplication.shared.applicationState == .active {
            print("⚠️ [GEOFENCE] didEnterRegion ignorado porque APP está en foreground: \(region.identifier)")
            return
        }

        print("🟩 ENTREEE → region: \(region.identifier)")
        guard let uuid = UUID(uuidString: region.identifier) else { return }
        registroManager?.registrarEntrada(sucursalID: uuid)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if UIApplication.shared.applicationState == .active {
            print("⚠️ [GEOFENCE] didExitRegion ignorado porque APP está en foreground: \(region.identifier)")
            return
        }

        print("🟥 SAAALIII → region: \(region.identifier)")
        guard let uuid = UUID(uuidString: region.identifier) else { return }
        registroManager?.registrarSalida(sucursalID: uuid)
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("❌ [GEOFENCE] ERROR:", error.localizedDescription)
    }
}

extension GeofencingManager {
    
    func simulateEnter(regionID: UUID) {
        print("🟩 [SIM] simulateEnter for \(regionID)")
        registroManager?.registrarEntrada(sucursalID: regionID)
    }

    func simulateExit(regionID: UUID) {
        print("🟥 [SIM] simulateExit for \(regionID)")
        registroManager?.registrarSalida(sucursalID: regionID)
    }
}
