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
        manager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        print("🔥 startUpdatingLocation() llamado con estado:", manager.authorizationStatus.rawValue)
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedWhenInUse:
            startUpdatingLocation()
        case .authorizedAlways:
            startUpdatingLocation()
        default:
            break
        }
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("📍 didUpdateLocations entregó:", locations.last?.coordinate ?? "nil")
        userLocation = locations.last

        if let loc = userLocation {
            registroManager?.processLocation(loc)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error de ubicación:", error.localizedDescription)
    }
}
