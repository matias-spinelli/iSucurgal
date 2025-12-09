//
//  LocationManager.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationManager: NSObject, ObservableObject {

    private let manager = CLLocationManager()

    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?

    weak var registroManager: RegistroManager?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }

    func requestAuthorization() {
        print("📍 Solicitando autorización ALWAYS…")
        manager.requestAlwaysAuthorization()
    }

    func start() {
        print("🚀 LocationManager.start()")

        manager.startMonitoringSignificantLocationChanges()
        manager.startUpdatingLocation()
    }

    func stop() {
        print("🛑 LocationManager.stop()")
        manager.stopUpdatingLocation()
        //manager.stopMonitoringSignificantLocationChanges()
    }
    
    func enterForeground() {
        print("☀️ App volvió a FOREGROUND → Reactivamos GPS preciso")
        start()
    }

    func enterBackground() {
        print("🌙 App pasó a BACKGROUND → Desactivamos GPS preciso")
        stop()
    }
}

// MARK: - Delegate

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorizationStatus = status

        print("🛂 [LOC] Authorization:", status.rawValue)

        switch status {
        case .authorizedAlways:
            start()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            print("🔴 Sin permisos suficientes")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let loc = locations.last else { return }

        print("📍 [LOC] Update:", loc.coordinate)
        userLocation = loc

        registroManager?.processLocation(loc)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error:", error.localizedDescription)
    }
}
