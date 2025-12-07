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

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        // muy importante para background
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }

    func requestAuthorization() {
        // primero pide WhenInUse
        manager.requestWhenInUseAuthorization()

        // cuando el usuario acepte, recién pedimos Always
        // (esto se dispara en didChangeAuthorization)
    }

    func startUpdatingLocation() {
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
            manager.requestAlwaysAuthorization()

        case .authorizedAlways:
            startUpdatingLocation()

        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error de ubicación:", error.localizedDescription)
    }
}
